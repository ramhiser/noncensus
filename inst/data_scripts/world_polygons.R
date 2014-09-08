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
remaining <- levels(factor(ww_full$group))[3744:3789]
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



save(world_polygons, file="../../data/world_polygons.RData", compress='xz')
