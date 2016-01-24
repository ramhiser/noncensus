#' Start a Shiny Application for Choropleths
#'
#' This function takes a dataframe and generates a local Shiny application for 
#' visualizing the results in a choropleth.
#'
#' NOTE: The \code{leaflet} R package must be installed.
#'
#' @export
#' @importFrom shiny runApp
#' @importFrom dplyr mutate
#' @importFrom RColorBrewer brewer.pal
#' @param df The dataframe with column "fips" (the FIPS 
#' code of the areas to show), with a column for the data to show, 
#' and a column for the grouping variable (if specifing categories)
#' @param fill The name of the variable to show in the choropleth
#' @param categories The name of the (optional) grouping variable on which to
#' divide the data
#' @param map The level at which to draw the map. Options are \code{county},
#' \code{state}, and \code{world}
#' @param palette An RColorBrewer palette to use. Default is \code{Blues}
#' @param background One of \code{Base}, \code{Greyscale}, \code{Physical}, or
#' \code{None}, to have as the background tiles for the map
#' @param cuts An optional vector specifying where to make the color breaks. 
#' Default cuts are the 20th, 40th, 60th, and 80th percentiles
#' @param dir The directory in which to create the Shiny app. Defaults to
#' \code{\link[base]{tempdir}}
#' 
#' @examples
#' data(population_age, package = "noncensus")
#' shiny_choro(population_age, fill = "population", categories = "age_group",
#'             map = "county", palette = "Purples", background = "Grey")
#' 
shiny_choro <- function(df, fill, categories = NULL, 
                        map = c("county", "state", "world"),
                        palette = "Blues",  
                        background = c("Base", "Greyscale", "Physical", "None"), 
                        cuts = NULL, dir = NULL) {
  
  if (!require(leaflet)) {
    stop("You must have 'leaflet' installed to run the Shiny application 
         -- try: install_github('jcheng5/leaflet-shiny').",
         call. = F)
  }
  
  df <- dplyr::tbl_df(df)
  
  if (is.null(dir)) {
    dir <- file.path(tempdir(), "shiny_choro")
    on.exit(unlink(dir, recursive=TRUE))
  }
  dir <- path.expand(dir)
  
  if (!("fips" %in% names(df))) {
    stop("df must contain 'fips' column")
  }
  
  fill <- as.character(fill)
  if (!(fill %in% names(df))) {
    stop("df does not contain fill column")
  }
  
  if (is.null(categories)) {
    df <- df[, c("fips", fill)]
    old_names <- fill
    names(df)[2] <- "fill"
  } else {
    categories <- as.character(categories)
    if (!(categories %in% names(df))) {
      stop("df does not contain categories column")
    }
    
    df <- df[, c("fips", categories, fill)]
    old_names <- c(fill, categories)
    names(df)[2:3] <- c("categories", "fill")
    df$categories <- factor(df$categories)
  }
  
  map <- match.arg(map)
  background <- match.arg(background)
  
  tiles <- c("Base" = "http://{s}.tile.openstreetmap.se/hydda/base/{z}/{x}/{y}.png",
             "Greyscale" = "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png",
             "Physical" = "http://server.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer/tile/{z}/{y}/{x}")
  attributes <- c("Base" = 'Tiles courtesy of <a href="http://hot.openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map df &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
                  "Greyscale" = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map df &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
                  "Physical" = "Tiles &copy; Esri &mdash; Source: US National Park Service")
  tile <- ifelse(background == "None", NA, tiles[background])
  attribute <- ifelse(background == "None", NA, attributes[background])
  
  dir.create(dir, showWarnings=FALSE, recursive=TRUE)
  dir.create(file.path(dir, 'data'), showWarnings=FALSE, recursive=TRUE)
  
  file.copy(file.path(system.file(package = "noncensus"), "shiny/."), 
            file.path(dir), recursive=TRUE)
  
  if (is.null(cuts)) {
    if (is.numeric(df$fill)) {
      cuts <- unique(quantile(df$fill, seq(0, 1, 1/5), na.rm = TRUE))
      df <- mutate(df, fillKey = cut_nice(df$fill, cuts, 
                                                    ordered_result = TRUE))
      df$colorBuckets <- as.numeric(df$fillKey)
      leg_txt <- levels(df$fillKey)
    } else {
      cuts <- levels(factor(df$fill))
      df$colorBuckets <- as.numeric(df$fill)
      leg_txt <- cuts
    }
  }
  
  fill_colors <- unlist(brewer.pal(length(cuts) - 1, palette))
  df$color <- fill_colors[df$colorBuckets]
  
  # TODO: Could add cat/legend labels or loquesea here later too
  extras <- list("bg_tile" = tile, "bg_attr" = attribute, "colors" = fill_colors,
                 "legend" = leg_txt, "old" = old_names, "map" = map)
  
  # Copies data to temp files to be loaded by Shiny app
  saveRDS(df, file = file.path(dir, "data/data.rds"))
  saveRDS(extras, file = file.path(dir, "data/extras.rds"))
  
  message("The files necessary for launching the Shiny application have ",
          "been copied to '", dir, "'.")
  
  shiny::runApp(file.path(dir))
}


#' Plot a Choropleth
#'
#' This function takes a dataframe and generates a choropleth plot
#'
#' @export
#' @importFrom RColorBrewer brewer.pal
#' @param df The dataframe with column "fips" (the FIPS 
#' code of the counties or states to show), with a column for the data to show
#' @param fill The name of the variable to show in the choropleth
#' @param map The level at which to draw the map. Options are "county", "state", 
#' "world" 
#' @param palette An RColorBrewer palette to use. Default is "Blues"
#' @param cuts An optional vector specifying where to make the color breaks 
#' Default cuts are the 20th, 40th, 60th, and 80th percentiles
#' @param continental A logical whether to show the continental US
#' 
#' @examples
#' data(population_age, package = "noncensus")
#' df <- plyr::ddply(population_age, "fips", summarize, population = sum(population))
#' plot_choro(df, fill = "population", map = "county", palette = "Purples", 
#' continental = TRUE)
#' 
plot_choro <- function(df, fill, map = c("county", "state", "world"), 
                       palette = "Blues", 
                       cuts = NULL, continental = T){
  if (!("fips" %in% names(df))) {
    stop("df must contain 'fips' column")
  }
  
  if (length(map) > 1) map <- map[1]
  map <- match.arg(map)
  
  if (is.null(cuts)){
    if (is.numeric(df[,fill])) {
      cuts <- unique(quantile(df[,fill], seq(0, 1, 1/5), na.rm = TRUE))
      df <- mutate(df, fillKey = cut_nice(df[,fill], cuts, 
                                                    ordered_result = TRUE))
      df$colorBuckets <- as.numeric(df$fillKey)
      leg_txt <- levels(df$fillKey)
    } else {
      cuts <- levels(factor(df[,fill]))
      df$colorBuckets <- as.numeric(df[,fill])
      leg_txt <- cuts
    }
  }
  
  fill_colors <- unlist(brewer.pal(length(cuts) - 1, palette))
  df$color <- fill_colors[df$colorBuckets]
  
  if (map == "county") {
    data(county_polygons)
    df_poly <- left_join(county_polygons, df, by = "fips")
  } else if (map == "state"){
    data(state_polygons)
    df_poly <- left_join(state_polygons, df, by = "fips")
  } else {
    data(world_polygons)
    world_polygons <- filter(world_polygons, !is.na(fips))
    df_poly <- left_join(world_polygons, df, by = "fips")
  }
  
  df_poly <- tbl_df(df_poly)
  df_poly <- arrange(df_poly, order)
  
  fips_colors <- df_poly %>% filter(!is.na(lat)) %>%
    dplyr::select(fips, color, group) %>%
    unique %>%
    arrange(group)

  
  if (map == "world"){
    plot(c(-180,180), c(-80,80), type = "n", xaxt='n', yaxt = 'n', ann=FALSE)
    polygon(df_poly[,c("long", "lat")], col = fips_colors$color)
    legend("bottomleft", legend = leg_txt, fill = fill_colors, cex = 0.6, 
           text.width = 50)
  } else {
    if (continental){
      plot(c(-125,-68), c(25,50), type = "n", xaxt='n', yaxt = 'n', ann=FALSE)
      polygon(df_poly[,c("long", "lat")], col = fips_colors$color)
      legend("bottomright", legend = leg_txt, fill = fill_colors, cex = 0.6, 
             text.width = 5)
    } else {
      plot(c(-190,-68), c(17,70), type = "n", xaxt='n', yaxt = 'n', ann=FALSE)
      polygon(df_poly[,c("long", "lat")], col = fips_colors$color)
      legend("topright", legend = leg_txt, fill = fill_colors, cex = 0.6, 
             text.width = 15)
    }
  }
}


# Helper function based on base:::cut.default()
cut_nice <- function (x, breaks, labels = NULL, include.lowest = TRUE,
                      right = TRUE, dig.lab = 3L, ordered_result = FALSE, ...) {
  if (!is.numeric(x)) {
    stop("'x' must be numeric")
  }
  if (length(breaks) == 1L) {
    if (is.na(breaks) || breaks < 2L) {
      stop("invalid number of intervals")
    }
    nb <- as.integer(breaks + 1)
    dx <- diff(rx <- range(x, na.rm = TRUE))
    if (dx == 0) {
      dx <- abs(rx[1L])
      breaks <- seq.int(rx[1L] - dx/1000, rx[2L] + dx/1000, 
                        length.out = nb)
    }
    else {
      breaks <- seq.int(rx[1L], rx[2L], length.out = nb)
      breaks[c(1L, nb)] <- c(rx[1L] - dx/1000, rx[2L] + 
                               dx/1000)
    }
  }
  else {
    nb <- length(breaks <- sort.int(as.double(breaks)))
  }
  if (anyDuplicated(breaks)) {
    stop("'breaks' are not unique")
  }
  codes.only <- FALSE
  if (is.null(labels)) {
    for (dig in dig.lab:max(12L, dig.lab)) {
      ch.br <- formatC(breaks, digits = dig, width = 1L, format = 'fg')
      if (ok <- all(ch.br[-1L] != ch.br[-nb])) {
        break
      }
    }
    labels <- if (ok) 
      paste0(if (right) 
        "("
        else "[", ch.br[-nb], ",", ch.br[-1L], if (right) 
          "]"
        else ")")
    else paste("Range", seq_len(nb - 1L), sep = "_")
    if (ok && include.lowest) {
      if (right) 
        substr(labels[1L], 1L, 1L) <- "["
      else substring(labels[nb - 1L], nchar(labels[nb - 1L], "c")) <- "]"
    }
  }
  else if (is.logical(labels) && !labels) 
    codes.only <- TRUE
  else if (length(labels) != nb - 1L) 
    stop("lengths of 'breaks' and 'labels' differ")
  code <- .bincode(x, breaks, right, include.lowest)
  if (codes.only) 
    code
  else factor(code, seq_along(labels), labels, ordered = ordered_result)
}
