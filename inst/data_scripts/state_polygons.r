library(maps)
library(dplyr)
library(reshape2)
library(stringr)
library(ggplot2)

# Assumes getwd() == './inst/data_scripts/'
state_key <- tbl_df(read.csv("../raw_data/fips_codes.csv", stringsAsFactors = F))
state_key$state2 <- tolower(fips_key$state)
state_key <- select(state_key, state, state2, state_code)
names(state_key)[3] <- "fips"
state_key <- unique(state_key)

m_state <- map("state", plot=FALSE, fill=TRUE)
state_df <- fortify(m_state)
state_df$subregion <- NULL
state_df <- merge(state_df, state_key, by.x = "region", by.y = "state2")

order <- data.frame("order" = 1:max(state_df$order))
state_df <- merge(order, state_df, by = "order", all.x = T)
nas <- which(is.na(state_df$group))
state_df[nas, c("fips", "group", "state")] <- state_df[nas+1, c("fips", "group", "state")]
state_df <- state_df %>% arrange(group, order)
state_df$region <- NULL


tmpdir <- tempdir()
fle <- basename("http://www2.census.gov/geo/tiger/GENZ2013/cb_2013_us_state_20m.zip")
download.file("http://www2.census.gov/geo/tiger/GENZ2013/cb_2013_us_state_20m.zip", fle)
unzip(fle, exdir = tmpdir)
tt <- readShapeSpatial(paste(path.expand(tmpdir), "cb_2013_us_state_20m.shp", sep = "/"))
unlink(tmpdir)
proj4string(tt) <- CRS("+proj=longlat +datum=NAD27")
st <- fortify(tt)

hi_poly <- NULL
ak_poly <- NULL

hst <- filter(st, long < -150, lat < 23)
i <- max(state_df$order) + 1
j <- max(state_df$group) + 1
for (gp in levels(factor(hst$group))){
  tmp2 <- filter(hst, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 15
  tmp2$state <- "Hawaii"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp2)
  j <- j + 1
  hi_poly <- rbind(hi_poly, tmp2)
}
hi_poly <- select(hi_poly, order, long, lat, group, state, fips)


ast <- filter(st, lat > 50)
ast$long[which(ast$long > 150)] <- -180 - 
  (180 - ast$long[which(ast$long > 150)])

for (gp in levels(factor(ast$group))){
  tmp2 <- filter(ast, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2
  tmp2$state <- "Alaska"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp2)
  j <- j + 1
  ak_poly <- rbind(ak_poly, tmp2)
}
ak_poly <- select(ak_poly, order, long, lat, group, state, fips)

state_polygons <- rbind(state_df, hi_poly, ak_poly)


save(state_polygons, file="../../data/state_polygons.RData", compress='xz')
