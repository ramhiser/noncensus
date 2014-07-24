shiny_choro <- function(df, categories, fill, palette = "Blues", cuts = NULL, 
                        background = c("Base", "Greyscale", "Physical", "None"), dir = NULL){
 
  if (!require(shiny)) {
    stop("You must have 'shiny' installed to run the Shiny application -- try 'install.packages(\"shiny\")'.",
         call. = F)
  }
  
  if (is.null(dir)) {
    dir <- file.path(tempdir(), "shinyChoro")
    on.exit(unlink(dir, recursive = T))
  }
  dir <- path.expand(dir)
  
  categories <- as.character(categories)
  fill <- as.character(fill)
  
  if(!("fips" %in% names(df))) stop("df must contain 'fips' column")
  if(!(categories %in% names(df))) stop("df does not contain categories column")
  if(!(fill %in% names(df))) stop("df does not contain fill column")
  
  df <- df[,c("fips", categories, fill)]
  old_names <- c(categories, fill)
  names(df)[2:3] <- c("cat", "fill")
  df$cat <- factor(df$cat)
  
  
  background <- match.arg(background)
  tiles <- c("Base" = "http://{s}.tile.openstreetmap.se/hydda/base/{z}/{x}/{y}.png",
              "Greyscale" = "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png",
              "Physical" = "http://server.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer/tile/{z}/{y}/{x}")
  attributes <- c("Base" = 'Tiles courtesy of <a href="http://hot.openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map df &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
               "Greyscale" = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map df &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
               "Physical" = "Tiles &copy; Esri &mdash; Source: US National Park Service")
  tile <- ifelse(background == "None", NA, tiles[background])
  attribute <- ifelse(background == "None", NA, attributes[background])
  
  dir.create(dir, showWarnings = F, recursive = T)

  file.copy(file.path(system.file(package = "noncensus"), "shiny/."), 
            file.path(dir), recursive = T)
  
  if(is.null(cuts)) cuts <- unique(quantile(df$fill, seq(0, 1, 1/5)))

  
  fillColors <- unlist(RColorBrewer::brewer.pal(length(cuts) - 1, palette))
  df <- mutate(df, fillKey = cut(df$fill, cuts, ordered_result = T, dig.lab = 6))
  df$colorBuckets <- as.numeric(df$fillKey)
  leg_txt <- levels(df$fillKey)
  df$color <- fillColors[df$colorBuckets]
  
  
  # dir.create(file.path(dir, "df"), showWarnings = F)
  saveRDS(df, file = file.path(dir, "data", "data.rds"))
  
  # could add cat/legend labels or loquesea here later too
  extras <- list("bg_tile" = tile, "bg_attr" = attribute, "colors" = fillColors, "legend" = leg_txt, 
                 "old" = old_names)
  saveRDS(extras, file = file.path(dir, "data", "extras.rds"))
  
  
  message("The files necessary for launching the Shiny application have ",
          "been copied to '", dir, "'.")
  
  runApp(file.path(dir))
}