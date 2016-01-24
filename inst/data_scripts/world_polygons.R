library(rgdal)
library(dplyr)
library(ggplot2)

# Assumes getwd() == './inst/data_scripts/'
temp <- tempfile()
tmpdir <- tempdir()
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS-0.3.zip", temp)
unzip(temp, exdir = tmpdir)
ww <- readOGR(tmpdir, "TM_WORLD_BORDERS-0.3")
unlink(tmpdir)
unlink(temp)
ww_poly <- fortify(ww)
ww_attr <- ww@data
ww_attr$id <- row.names(ww_attr)
ww_full <- merge(ww_poly, ww_attr, by = "id")


## Add in polygon breaks
ww_na <- NULL
for (gp in levels(factor(ww_full$group))){
  tmp2 <- filter(ww_full, group == gp)
  tmp2 <- rbind(NA, tmp2)
  ww_na <- rbind(ww_na, tmp2)
}
ww_na$order <- 1:nrow(ww_na)

world_polygons <- select(ww_na, order, long, lat, group, NAME, FIPS, ISO2, 
                         ISO3, REGION, SUBREGION, UN)
names(world_polygons) <- c("order", "long", "lat", "group", "name", "fips", "ISO2", 
"ISO3", "region", "subregion", "UN_code")

world_polygons$group <- as.numeric(world_polygons$group)
## Palestine has two codes, we use "GZ" in place of "WB" here
levels(world_polygons$fips) <- c(levels(world_polygons$fips), "GZ")
world_polygons[which(world_polygons$name == "Palestine"),]$fips <- "GZ"
nas <- which(is.na(world_polygons$fips))
world_polygons[nas, c("fips", "name", "group", "ISO2", "ISO3", "UN_code")] <- 
  world_polygons[nas+1, c("fips", "name", "group", "ISO2", "ISO3", "UN_code")]

# remove starting NA row
world_polygons <- world_polygons[2:nrow(world_polygons),]
world_polygons$order <- 1:nrow(world_polygons)


save(world_polygons, file="../../data/world_polygons.RData", compress='xz')
