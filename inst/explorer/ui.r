shinyUI(fluidPage(
  div(class="outer",
      
      tags$head(
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      
      leafletMap("map", width="100%", height = "100%",
                 initialTileLayer = "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png",
                 initialTileLayerAttribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map df &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>', 
                 
                 options=list(
                   center = c(37.45, -93.85),
                   zoom = 4
                   #,
                  # maxBounds = list(list(15.961329,-129.92981), list(52.908902,-56.80481)) # Show US only
                 )
      ),
      absolutePanel(id = "controls", class = "modal", fixed = TRUE, 
                    draggable = TRUE, top = 20, left = "auto", right = 20, 
                    bottom = "auto", width = 300, height = "auto",
                    h4("Data to display"),
                    selectInput(inputId="level1",
                                label="Topics",
                                choices= c("Population", "Housing", "Income", 
                                           "Employment", "Sales")),
                    uiOutput("level2"), uiOutput("level3"),
                    actionButton("action", label = "Plot")
                    ),
      absolutePanel(id = "legend", class = "modal", fixed = TRUE, 
                    draggable = TRUE, top = 500, left = "auto", right = 20, 
                    bottom = "auto", width = 200, height = "auto",
                    
                    tags$div(class = "input-color", uiOutput("Legend"))
                       
      ))))