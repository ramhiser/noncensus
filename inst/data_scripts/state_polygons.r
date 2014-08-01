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

state_polygons <- state_df

save(state_polygons, file="../../data/state_polygons.RData", compress='xz')