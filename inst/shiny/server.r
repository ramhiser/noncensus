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
  
  output$cats <- renderUI({
    if (is.null(county_data$cat)) {
      return()
    }
    return(absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = TRUE,
                              top = 60, left = "auto", right = 20, bottom = "auto",
                              width = 330, height = 100, h4("Category select"),
    selectInput(inputId="cats",
                label="Categories",
                choices=county_cats)))
  })
  
  map <- createLeafletMap(session, "map")
  
  output$Legend <- renderUI({
    LL <- vector("list", length(fillColors))        
    for(i in 1:length(fillColors)){
      LL[[i]] <- list(tags$div(class = "color-box", 
                               style=paste("background-color:", 
                                           fillColors[i], ";")), 
                      p(leg_txt[i]), tags$br())
    }
    return(LL)
  })
  
  
  # session$onFlushed is necessary to delay the drawing of the polygons until
  # after the map is created
  session$onFlushed(once=TRUE, function() {
    
    companyToUse <- reactive({
      if (is.null(input$cats)){
        comp_two
      } else {
      filter(comp_two,
             cat == input$cats | is.na(cat))
      
      }
    })
    
    
    paintObs <- observe({
      
      comp_data <- companyToUse()
      
      map$clearShapes()
      fips_colors <- unique(comp_data[!is.na(comp_data$color),c("fips", "color", "group")])
      fips_colors <- merge(data.frame("group" = 1:max(comp_data$group, na.rm = T)), 
                           fips_colors, by = "group", all.x = T)
      
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
        county <- cdata[cdata$group == event$id,]
        center <- county %>% 
          group_by("fips", "names", "county", "fill") %>% filter(!is.na(lat)) %>% 
          summarize(clong = mean(long), clat = mean(lat)) 
        content <- as.character(tagList(
          tags$strong(center$county),
          tags$br(),
          paste(fill_name, ": ", formatC(center$fill, format = 'fg'))
        ))
        map$showPopup(center$clat, center$clong, content, event$id)
      })
    })
    session$onSessionEnded(clickObs$suspend)
  })
})