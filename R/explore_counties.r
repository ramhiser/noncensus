#' Explore U.S. Census Quick Facts
#'
#' This function launches a Shiny app for quick visualization of the 
#' \code{quick_facts} dataset. The Shiny, dplyr, leaflet, and RColorBrewer 
#' libraries must be installed.
#'
#' @export
#' @seealso \code{\link{quick_facts}} for a description of the dataset
#' 
#' @example
#' explore_counties()
#'

explore_counties <- function(){
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
  if (!require(RColorBrewer)) {
    stop("You must have 'RColorBrewer' installed to run the Shiny application 
         -- try: install.packages('RColorBrewer').",
         call. = F)
  }
  if (!require(leaflet)) {
    stop("You must have 'leaflet' installed to run the Shiny application 
         -- try: install_github('jcheng5/leaflet-shiny').",
         call. = F)
  }
  
  shiny::runApp(file.path(system.file(package = "noncensus"), "explorer"))
}