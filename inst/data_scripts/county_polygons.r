library(maps)
library(maptools)
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)
library(ggplot2)

# Assumes getwd() == './inst/data_scripts/'
fips_key <- tbl_df(read.csv("../raw_data/fips_codes.csv", stringsAsFactors = F))
fips_key$state <- tolower(fips_key$state)
fips_key$county_cap <- fips_key$county
fips_key$county <- tolower(fips_key$county)
fips_key$fips <- 1000*fips_key$state_code + fips_key$county_code

m_counties <- map("county", plot=FALSE, fill=TRUE)
names <- colsplit(m_counties$names, pattern = ",", names = c('state', 'county'))
m_counties$state <- names[[1]]
m_counties$county <- names[[2]]
key <- data.frame("state" = names[[1]], "county" = names[[2]])
key <- merge(key, fips_key[,c("state","county","fips")], by = c("state", "county"), all.x = T)
key <- unique(key)
key$joined <- do.call(paste, c(key[c("state", "county")], sep = ","))
m_counties$fips <- key$fips[match(m_counties$names, key$joined)]
m_counties$names <- unname(sapply(m_counties$names, function(x){str_replace(x, ":[a-z ]*", "")}))


counties_df <- fortify(m_counties) 
counties_df$names <- do.call(paste, c(counties_df[,c("region", "subregion")], sep = ","))
counties_df$fips <- key$fips[match(counties_df$names, key$joined)]
counties_df$fips[which(counties_df$names == "washington,pierce")] <- 53053
counties_df$fips[which(counties_df$names == "louisiana,st martin")] <- 22099
counties_df$fips[which(counties_df$names == "texas,galveston")] <- 48167
counties_df$fips[which(counties_df$names == "florida,okaloosa")] <- 12091
counties_df$fips[which(counties_df$names == "washington,san juan")] <- 53055
counties_df$fips[which(counties_df$names == "virginia,accomack")] <- 51001
counties_df$fips[which(counties_df$names == "montana,yellowstone national")] <- 30111
counties_df$fips[which(counties_df$names == "district of columbia,washington")] <- 110001

counties_df$county <-  fips_key$county_cap[match(counties_df$fips, fips_key$fips)]

order <- data.frame("order" = 1:max(counties_df$order))
counties_df <- merge(order, counties_df, by = "order", all.x = T)
nas <- which(is.na(counties_df$fips))
counties_df[nas, c("fips", "names", "group", "county")] <- counties_df[nas+1, c("fips", "names", "group", "county")]
counties_df <- counties_df %>% arrange(group, order)

counties_df$region <- NULL
counties_df$subregion <- NULL
counties_df <- counties_df[ ,c("order", "fips", "names", "group", "lat", "long", "county")]
counties_df <- counties_df[1:91030,] # removes unnamed rows


tmpdir <- tempdir()
fle <- basename("http://dds.cr.usgs.gov/pub/data/nationalatlas/countyp010g.shp_nt00934.tar.gz")
download.file("http://dds.cr.usgs.gov/pub/data/nationalatlas/countyp010g.shp_nt00934.tar.gz", fle)
untar(fle, compressed = 'gzip', exdir = tmpdir)
tt <- readShapeSpatial(paste(path.expand(tmpdir), "countyp010g.shp", sep = "/"))
unlink(tmpdir)
proj4string(tt) <- CRS("+proj=longlat +datum=NAD27")
test2 <- fortify(tt)


## Hawaii polygons (State 15) #####
htest <- filter(test2, long < -150, lat < 23)


i <- max(counties_df$order) + 1
j <- max(counties_df$group) + 1
tmp <- filter(htest, group == 467.1)
tmp <- rbind(NA, tmp)
tmp$fips <- 15001
tmp$county <- "Hawaii"
tmp$names <- "hawaii,hawaii"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- select(tmp, order, fips, names, group, lat, long, county)

tmp <- filter(htest, group == 3027.1)
tmp <- rbind(NA, tmp)
tmp$fips <- 15003
tmp$county <- "Honolulu"
tmp$names <- "hawaii,honolulu"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))


tmp <- filter(htest, group == 3028.1)
tmp <- rbind(NA, tmp)
tmp$fips <- 15007
tmp$county <- "Kauai"
tmp$names <- "hawaii,kauai"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))

tmp <- filter(htest, group == 3028.2)
tmp <- rbind(NA, tmp)
tmp$fips <- 15007
tmp$county <- "Kauai"
tmp$names <- "hawaii,kauai"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))

tmp <- filter(htest, group == 3029.1)
tmp <- rbind(NA, tmp)
tmp$fips <- 15009
tmp$county <- "Maui"
tmp$names <- "hawaii,maui"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))

tmp <- filter(htest, group == 3029.2)
tmp <- rbind(NA, tmp)
tmp$fips <- 15009
tmp$county <- "Maui"
tmp$names <- "hawaii,maui"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))

tmp <- filter(htest, group == 3029.3)
tmp <- rbind(NA, tmp)
tmp$fips <- 15009
tmp$county <- "Maui"
tmp$names <- "hawaii,maui"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))

tmp <- filter(htest, group == 3029.4)
tmp <- rbind(NA, tmp)
tmp$fips <- 15009
tmp$county <- "Maui"
tmp$names <- "hawaii,maui"
tmp$order <- seq(i, length = nrow(tmp))
tmp$group <- j
i <- i + nrow(tmp)
j <- j + 1
new_poly <- rbind(new_poly, select(tmp, order, fips, names, group, lat, long, county))





### Alaska polygons (State 2) ####
atest <- filter(test2, lat > 50)
atest$long[which(atest$long > 150)] <- -180 - 
  (180 - atest$long[which(atest$long > 150)])


alaska_poly <- NULL


tmp <- filter(atest, id == 2973)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2013
  tmp2$county <- "Aleutians East"
  tmp2$names <- "alaska,aleutians east"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}



tmp <- filter(atest, id == 2974)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2016
  tmp2$county <- "Aleutians West"
  tmp2$names <- "alaska,aleutians west"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 2975)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2020
  tmp2$county <- "Anchorage"
  tmp2$names <- "alaska,anchorage"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 2976)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2050
  tmp2$county <- "Bethel"
  tmp2$names <- "alaska,bethel"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 2977)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2060
  tmp2$county <- "Bristol Bay"
  tmp2$names <- "alaska,bristol bay"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 2978)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2070
  tmp2$county <- "Dillingham"
  tmp2$names <- "alaska,dillingham"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 2979)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2185
  tmp2$county <- "North Slope"
  tmp2$names <- "alaska,north slope"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 2980)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2188
  tmp2$county <- "Northwest Arctic"
  tmp2$names <- "alaska,northwest arctic"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 2981)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2270
  tmp2$county <- "Wade Hampton"
  tmp2$names <- "alaska,wade hampton"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 3181)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2164
  tmp2$county <- "Lake and Peninsula"
  tmp2$names <- "alaska,lake and peninsula"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 3182)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2150
  tmp2$county <- "Kodiak Island"
  tmp2$names <- "alaska,kodiak island"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 3183)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2122
  tmp2$county <- "Kenai Peninsula"
  tmp2$names <- "alaska,kenai peninsula"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}



tmp <- filter(atest, id == 3184)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2261
  tmp2$county <- "Valdez-Cordova"
  tmp2$names <- "alaska,valdez-cordova"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3185)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2130
  tmp2$county <- "Ketchikan Gateway"
  tmp2$names <- "alaska,ketchikan gateway"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 3186)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2110
  tmp2$county <- "Juneau"
  tmp2$names <- "alaska,juneau"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 3187)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2100
  tmp2$county <- "Haines"
  tmp2$names <- "alaska,haines"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 3188)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2220
  tmp2$county <- "Sitka"
  tmp2$names <- "alaska,sitka"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3189)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2282
  tmp2$county <- "Yakutat"
  tmp2$names <- "alaska,yakutat"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}



tmp <- filter(atest, id == 3198)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2180
  tmp2$county <- "Nome"
  tmp2$names <- "alaska,nome"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3204)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2105
  tmp2$county <- "Hoonah-Angoon"
  tmp2$names <- "alaska,hoonah-angoon"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3205)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2230
  tmp2$county <- "Skagway"
  tmp2$names <- "alaska,skagway"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3206)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2275
  tmp2$county <- "Wrangell"
  tmp2$names <- "alaska,wrangell"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3207)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- NA
  tmp2$county <- "Petersburg"
  tmp2$names <- "alaska,petersburg"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 3214)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2198
  tmp2$county <- "Prince of Wales-Hyder"
  tmp2$names <- "alaska,prince of wales-hyder"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 64)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2068
  tmp2$county <- "Denali"
  tmp2$names <- "alaska,denali"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}


tmp <- filter(atest, id == 65)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2090
  tmp2$county <- "Fairbanks North Star"
  tmp2$names <- "alaska,fairbanks north star"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 66)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2170
  tmp2$county <- "Matanuska-Susitna"
  tmp2$names <- "alaska,matanuska-susitna"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 67)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2240
  tmp2$county <- "Southeast Fairbanks"
  tmp2$names <- "alaska,southeast fairbanks"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}

tmp <- filter(atest, id == 68)
for (gp in levels(factor(tmp$group))){
  tmp2 <- filter(tmp, group == gp)
  tmp2 <- rbind(NA, tmp2)
  tmp2$fips <- 2290
  tmp2$county <- "Yukon-Koyukuk"
  tmp2$names <- "alaska,yukon-koyukuk"
  tmp2$order <- seq(i, length = nrow(tmp2))
  tmp2$group <- j
  i <- i + nrow(tmp)
  j <- j + 1
  alaska_poly <- rbind(alaska_poly, tmp2)
}
alaska_poly <- select(alaska_poly, order, fips, names, group, lat, long, county)


county_polygons <- rbind(counties_df, new_poly, alaska_poly)

save(county_polygons, file="../../data/county_polygons.RData", compress='xz')
