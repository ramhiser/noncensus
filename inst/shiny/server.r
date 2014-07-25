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
    
    
    paintObs <- observe({
    
      
      map$clearShapes()
      fips_colors <- unique(comp_two[!is.na(comp_two$color),c("fips", "color", "group")])
      fips_colors <- merge(data.frame("group" = 1:max(comp_two$group, na.rm = T)), 
                           fips_colors, by = "group", all.x = T)
      
      map$addPolygon(comp_two$lat, comp_two$long, 
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
        county <- comp_two[comp_two$group == event$id,]
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