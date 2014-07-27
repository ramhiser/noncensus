library(maps)
library(dplyr)
library(reshape2)
library(stringr)
library(ggplot2)

fips_key <- tbl_df(read.csv("data/fips_codes.csv", stringsAsFactors = F))
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

write.csv(counties_df, "fips_polygons.csv")
