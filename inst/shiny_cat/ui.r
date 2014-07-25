shinyUI(fluidPage(
  div(class="outer",
      
      tags$head(
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      
      leafletMap("map", width="100%", height="100%",
                 initialTileLayer = tile,
                 initialTileLayerAttribution = attr, 
                 
                 options=list(
                   center = c(37.45, -93.85),
                   zoom = 4,
                   maxBounds = list(list(15.961329,-129.92981), list(52.908902,-56.80481)) # Show US only
                 )
      ),
      
      absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = TRUE,
                    top = 60, left = "auto", right = 20, bottom = "auto",
                    width = 330, height = 100,
                    
                    h4("Category select"),
                    selectInput("category", cat_name, levels(county_data$cat))
      ), 
      
      
      absolutePanel(id = "legend", class = "modal", fixed = TRUE, draggable = TRUE,
                    top = 200, left = "auto", right = 20, bottom = "auto",
                    width = 200, height = "auto",
                    
                    tags$div(class = "input-color", uiOutput("Legend"))
      ),
      
      
      conditionalPanel("false", icon("crosshair"))
  )))