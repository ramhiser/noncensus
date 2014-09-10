bindEvent <- function(eventExpr, callback, env=parent.frame(), quoted=FALSE) {
  eventFunc <- exprToFunction(eventExpr, env, quoted)
  
  initialized <- FALSE
  invisible(observe({
    eventVal <- eventFunc()
    if (!initialized)
      initialized <<- TRUE
    else
      isolate(callback())
  }))
}


shinyServer(function(input, output, session) {
  
  map <- createLeafletMap(session, "map")
  
  output$Legend <- renderUI({
    LL <- vector("list", length(fillColors))        
    for (i in seq_along(fillColors)) {
      LL[[i]] <- list(tags$div(class = "color-box", 
                               style=paste("background-color:", 
                                           fillColors[i], ";")), 
                      p(leg_txt[i]), tags$br())
    }
    return(LL)
  })
  
  output$cats <- renderUI({
    if(is.null(comp_two$categories)){
      return(NULL)
    }
    
    return(absolutePanel(id = "controls", class = "modal", fixed = TRUE, 
                         draggable = TRUE, top = 20, left = "auto", right = 20, 
                         bottom = "auto", width = 200, height = "auto",
                         h4("Category select"),
           selectInput(inputId="cats",
                       label="Category to show",
                       choices=county_cats)))
  })
  
  
  # session$onFlushed is necessary to delay the drawing of the polygons until
  # after the map is created
  session$onFlushed(once=TRUE, function() {
    
    companyToUse <- reactive({
      if (is.null(comp_two$categories)) {
        comp_two
      } else {
        filter(comp_two,
               categories == input$cats | is.na(categories))
      }
    })
    
    paintObs <- observe({
      
      comp_data <- companyToUse()
      
      map$clearShapes()

      fips_colors <- comp_data %>% dplyr::filter(!is.na(color)) %>%
        dplyr::select(fips, color, group) %>%
        unique(.)

      max_group <- max(comp_data$group, na.rm=TRUE)
      groups_df <- tbl_df(data.frame(group=seq_len(max_group)))

      fips_colors <- merge(groups_df, fips_colors, by = "group", all.x = T)

      map$addPolygon(comp_data$lat, comp_data$long, 
                     fips_colors$group,
                     lapply(fips_colors$color, function(x) {
                       list(fillColor = x)
                     }),
                     list(fill=T, fillOpacity=1,
                          stroke=TRUE, opacity=1, color="white", weight=1)
      )
    })
    
    session$onSessionEnded(paintObs$suspend)
    
    clickObs <- observe({
      event <- input$map_shape_click
      if (is.null(event))
        return()
      map$clearPopups()
      
      isolate({
        cdata <- companyToUse()
        county <- cdata[cdata$group == event$id, ]
        if (grain == "county") {
          center <- county %>% 
            group_by("fips", "names", "county", "fill") %>% filter(!is.na(lat)) %>% 
            summarize(clong = mean(long), clat = mean(lat)) 
          names(center)[3] <- "grain"
          
        } else if (grain == "state") {
          center <- county %>% 
            group_by("fips", "state", "fill") %>% filter(!is.na(lat)) %>% 
            summarize(clong = mean(long), clat = mean(lat)) 
          names(center)[2] <- "grain"
        }
        #TODO: World polygons
        content <- as.character(tagList(
          tags$strong(center$grain),
          tags$br(),
          paste(fill_name, ": ", formatC(center$fill, format = 'fg'))
        ))
        map$showPopup(center$clat, center$clong, content, event$id)
      })
    })
    session$onSessionEnded(clickObs$suspend)
  })
})
