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
  
  
  output$level2 <- renderUI({
    if(is.null(input$level1)){
      return(NULL)
    }
    
    return(selectInput(inputId="level2",
                       label="",
                       choices= level2_names[[input$level1]]))
  })
  
  
  output$level3 <- renderUI({
    if(is.null(input$level1) | is.null(input$level2)){
      return(NULL)
    }
    
    if(input$level1 %in% c("Housing", "Income", "Sales")){
      return(NULL)
    } else if(input$level1 == "Population" & 
                input$level2 %in% c("Population per square mile", "Number of veterans")){
      return(NULL)
    } else if(input$level1 == "Employment" & input$level2 != "Number of firms"){
      return(NULL)
    }
    
    return(selectInput(inputId="level3",
                       label="",
                       choices= level3_names[[input$level2]]))
  })
  
  # session$onFlushed is necessary to delay the drawing of the polygons until
  # after the map is created
session$onFlushed(once=TRUE, function() {


  dataToUse <- reactive({
    i <- input$action
    isolate({

    
    if(is.null(input$level1) | is.null(input$level2) | 
         (input$level2 == "Population estimates" & is.null(input$level3))){
      return(NULL)
    }
    

    if(input$level1 %in% c("Housing", "Income", "Sales")){
      f_name <<- input$level2
      category <<- names(quick_facts)[which(full_names == input$level2) + 1]
      } else if((input$level1 == "Population") & 
                  (input$level2 %in% c("Population per square mile", "Number of veterans"))){
        f_name <<- input$level2
        category <<- names(quick_facts)[which(full_names == input$level2) + 1]
      } else if(input$level1 == "Employment" & input$level2 != "Number of firms"){
        f_name <<- input$level2
        category <<- names(quick_facts)[which(full_names == input$level2) + 1]
      } else {
        f_name <<- input$level3
        category <<- names(quick_facts)[which(full_names == input$level3) + 1]
      }
    
   comp_data <- comp_two[, c("fips", "order", "names", "group", "lat", "long", 
                             "county", category)]
   
   
     cuts <- c(unique(quantile(comp_data[,8], seq(0, 1, 1/5), na.rm = T)))
     fillColors <- unlist(brewer.pal(length(cuts) - 1, "YlOrRd"))

   
   comp_data$fillKey <- noncensus:::cut_nice(comp_data[,8], cuts, 
                                             ordered_result = T, 
                                             include.lowest = T)
   comp_data$colorBuckets <- as.numeric(comp_data$fillKey) 
   comp_data$color <- fillColors[comp_data$colorBuckets]
   comp_data$color <- factor(comp_data$color, ordered = T)

   nas <- which(is.na(comp_data[,category]) & !is.na(comp_data[,"lat"]))
   if(length(nas) > 0){
   levels(comp_data$color) <- c(levels(comp_data$color), "#E3E3E3")
   comp_data$color[nas] <- "#E3E3E3"
   levels(comp_data$fillKey) <- c(levels(comp_data$fillKey), "No data available")
   comp_data$fillKey[nas] <- "No data available"
   }
   
   comp_data <- comp_data %>% arrange(group, order)
   return(comp_data)
    })
  })
  
  
  paintObs <- observe({
    
      comp_data <- dataToUse()
      if(is.null(comp_data)){
        return()
      }
      
      
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
                          stroke=TRUE, opacity=1, color="grey", weight=1)
      )
    })
    
    session$onSessionEnded(paintObs$suspend)
  
  output$Legend <- renderUI({
    if(is.null(dataToUse()$color)){
      return()
    }
    
    leg_col <- levels(dataToUse()$color)
    #deal with switched order
    ln_col <- length(leg_col)
    leg_col <- c(leg_col[1:(ln_col - 1)][(ln_col-1):1], leg_col[ln_col])
    LL <- vector("list", length(leg_col))  
    leg_txt <- levels(dataToUse()$fillKey)
    for(i in 1:length(leg_col)){
      LL[[i]] <- list(tags$div(class = "color-box", 
                               style=paste("background-color:", 
                                           leg_col[i], ";")), 
                      p(leg_txt[i]), tags$br())
    }
    return(LL)
  })
    
    clickObs <- observe({
      event <- input$map_shape_click
      if (is.null(event))
        return()
      map$clearPopups()
      
      isolate({
        cdata <- dataToUse()
        county <- cdata[cdata$group == event$id,]
        names(county)[which(names(county) == category)] <- "fill"
          center <- county %>% 
            group_by("fips", "names", "county", "fill") %>% filter(!is.na(lat)) %>% 
            summarize(clong = mean(long), clat = mean(lat)) 
        content <- as.character(tagList(
          tags$strong(center$county),
          tags$br(),
          paste(f_name, ": ", formatC(center[,"fill"], format = 'fg'))
        ))
        map$showPopup(center$clat, center$clong, content, event$id)
      })
    })
    session$onSessionEnded(clickObs$suspend)
 })
})