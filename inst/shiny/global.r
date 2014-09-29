library(noncensus)
library(shiny)
library(leaflet)
library(dplyr)

county_data <- readRDS("data/data.rds")
extra_data <- readRDS("data/extras.rds")
grain <- extra_data$map
fillColors <- extra_data$colors
leg_txt <- extra_data$legend
fill_name <- extra_data$old[1]

if (length(extra_data$old) > 1) {
  cat_name <- extra_data$old[2]
  county_cats <- levels(factor(county_data$categories))
}

tile <- extra_data$bg_tile
if (is.na(tile)) {
  tile <- NULL
}

attr <- extra_data$bg_attr
if (is.na(attr)){ 
  attr <- NULL
}

if (grain == "world"){
  opts <- list(center = c(0, 0), zoom = 2)
} else {
  opts <- list(center = c(37.45, -93.85), zoom = 4)
}

if(!is.null(county_data$categories)){
  if (grain == "county"){
    data(county_polygons)
    comp_two <- dplyr::left_join(county_polygons, county_data, by = "fips")
  } else if (grain == "state"){
    data(state_polygons)
    comp_two <- dplyr::left_join(state_polygons, county_data, by = "fips")
  } else {
    data(world_polygons)
    world_polygons <- filter(world_polygons, !is.na(fips))
    comp_two <- dplyr::left_join(world_polygons, county_data, by = "fips")
  }
}

comp_two <- dplyr::tbl_df(comp_two)
comp_two <- comp_two %>% arrange(group, order)
