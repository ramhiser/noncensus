shinyUI(fluidPage(
  div(class="outer",
      
      tags$head(
        includeCSS("styles2.css"),
        includeScript("gomap.js")
      ),
      
      leafletMap("map", width="100%", height = map_height,
                 initialTileLayer = tile,
                 initialTileLayerAttribution = attr, 
                 
                 options=list(
                   center = c(37.45, -93.85),
                   zoom = 4,
                   maxBounds = list(list(15.961329,-129.92981), list(52.908902,-56.80481)) # Show US only
                 )
      ),
      uiOutput("Panel")
                       
      )))