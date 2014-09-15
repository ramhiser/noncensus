shinyUI(fluidPage(
  div(class="outer",
      
      tags$head(
        includeCSS("styles.css"),
        includeScript("gomap.js")
        ),
      leafletMap("map", width="100%", height = "100%",
                 initialTileLayer = tile,
                 initialTileLayerAttribution = attr, 
                 options = opts
                 ),
      uiOutput("cats"), 
      absolutePanel(id = "legend", class = "modal", fixed = TRUE, 
                    draggable = TRUE, top = 500, left = "auto", right = 20, 
                    bottom = "auto", width = 200, height = "auto",
                    tags$div(class = "input-color", uiOutput("Legend"))
      ))))
