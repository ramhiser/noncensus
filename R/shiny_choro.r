#' Start a Shiny Application for Choropleths
#'
#' This function takes a dataframe and generates a local Shiny application for 
#' visualizing the results in a choropleth. The Shiny, dplyr, and leaflet 
#' libraries must be installed.
#'
#' @export
#' @importFrom RColorBrewer brewer.pal
#' @param df The dataframe with at least three columns: One for "fips" (the FIPS 
#' code of the counties to show), one for the data to show, and one for 
#' grouping variable
#' @param fill The name of the variable to show in the choropleth. Must be 
#' continuous.
#' @param categories The name of the (optional) grouping variable on which to 
#' divide the data
#' @param palette An RColorBrewer palette to use. Default is "Blues"
#' @param background One of "Base", "Greyscale", "Physical", or "None", to have
#' as the background tiles for the map
#' @param cuts An optional vector specifying where to make the color breaks. 
#' Default cuts are the 20th, 40th, 60th, and 80th percentiles.
#' @param dir The directory in which to create the Shiny app. Defaults to
#' \code{\link[base]{tempdir}}.
#' 
#' @examples
#' data(population_age, package="noncensus")
#' shiny_choro(population_age, fill = "population", categories = "age_group",
#'             palette = "Purples", background = "Grey")
#' 
shiny_choro <- function(df, fill, categories = NULL, palette = "Blues",  
                        background = c("Base", "Greyscale", "Physical", "None"), 
                        cuts = NULL, dir = NULL) {
 
  if (!require(shiny)) {
    stop("You must have 'shiny' installed to run the Shiny application 
         -- try: install.packages('shiny').",
         call. = F)
  }
  if (!require(dplyr)) {
    stop("You must have 'dplyr' installed to run the Shiny application 
         -- try: install.packages('dplyr').",
         call. = F)
  }
  if (!require(leaflet)) {
    stop("You must have 'leaflet' installed to run the Shiny application 
-- try: install_github('jcheng5/leaflet-shiny').",
         call. = F)
  }
  
  if (is.null(dir)) {
    dir <- file.path(tempdir(), "shinyChoro")
    on.exit(unlink(dir, recursive = T))
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
    old_names <- c(categories, fill)
    names(df)[2:3] <- c("cat", "fill")
    df$cat <- factor(df$cat)
  }
  
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

  # TODO: Do we really need 2 shiny apps? Can we use 1 instead and add some
  # logic that conditionally uses categories or not?
  if (is.null(categories)) {
  file.copy(file.path(system.file(package = "noncensus"), "shiny/."), 
            file.path(dir), recursive = T)
  } else {
    file.copy(file.path(system.file(package = "noncensus"), "shiny_cat/."), 
              file.path(dir), recursive = T)
  }
  
  if (is.null(cuts)) {
    if (is.numeric(df$fill)) {
      cuts <- unique(quantile(df$fill, seq(0, 1, 1/5)))
    } else {
      cuts <- levels(factor(df$fill))
    }
  }
  
  fillColors <- unlist(brewer.pal(length(cuts) - 1, palette))
  df <- mutate(df, fillKey = cut_nice(df$fill, cuts, ordered_result = T))
  df$colorBuckets <- as.numeric(df$fillKey)
  leg_txt <- levels(df$fillKey)
  df$color <- fillColors[df$colorBuckets]
  
  # TODO: Could add cat/legend labels or loquesea here later too
  extras <- list("bg_tile" = tile, "bg_attr" = attribute, "colors" = fillColors,
                 "legend" = leg_txt, "old" = old_names)

  # Copies data to temp files to be laoded by Shiny app
  saveRDS(df, file = file.path(dir, "data.rds"))
  saveRDS(extras, file = file.path(dir, "extras.rds"))
  
  message("The files necessary for launching the Shiny application have ",
          "been copied to '", dir, "'.")
  
  runApp(file.path(dir))
}

# Helper function base on base:::cut.default()
cut_nice <- function (x, breaks, labels = NULL, include.lowest = FALSE,
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
      else substring(labels[nb - 1L], nchar(labels[nb - 
                                                     1L], "c")) <- "]"
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
