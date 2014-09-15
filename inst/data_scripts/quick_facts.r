library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

raw_data <- read.csv("http://quickfacts.census.gov/qfd/download/DataSet.txt", 
                     stringsAsFactors = F) 
data_flags <- read.csv("http://quickfacts.census.gov/qfd/download/DataFlags.txt", 
                       stringsAsFactors = F)
footnotes <- read.csv("http://quickfacts.census.gov/qfd/download/FootNotes.txt", 
                      stringsAsFactors = F)


flags <- which(data_flags[,-1] > 1, arr.ind = T)
for (i in 1:nrow(flags)){
  raw_data[flags[i,1], flags[i,2] + 1] <- NA
}

notes <- subset(footnotes, fcode %in% c(6004, 6021, 6509))
for (i in 1:nrow(notes)){
  raw_data[which(raw_data$fips == notes[i,2]), notes[i,1]] <- NA
}

quick_facts <- raw_data
names(quick_facts) <- c("fips", "population_2013", "population_2010_base", 
                     "population_change_percent", "population_2010", 
                     "percent_under_5", "percent_under_18", "percent_over_65", 
                     "percent_female", "percent_white", "percent_black", 
                     "percent_native", "percent_asian", "percent_hawaiian", 
                     "percent_two_plus", "percent_hispanic", "percent_white_NH", 
                     "percent_same_house_1yr", "percent_foreign", 
                     "percent_nonEnglish", "percent_high_school_grad", "percent_BA",
                     "veterans", "mean_travel_time", "housing_units", 
                     "homeownership", "percent_multi_unit", "median_value_housing",
                     "households", "pph", "per_capita_income", "med_hh_income",
                     "percent_poverty", "private_non_farm", 
                     "private_non_farm_employ", "pnfe_percent_change", 
                     "nonemployer_estab", "firms", "percent_black_firms", 
                     "percent_native_firms", "percent_asian_firms", 
                     "percent_hawaiian_firms", "percent_hispanic_firms", 
                     "percent_female_firms", "manu_shipments", "merchant_wholesales",
                     "retail_sales", "retail_sales_per_capita", "accom_food_sales", 
                     "building_permits", "land_area", "population_sq_mi")

quick_facts <- tbl_df(quick_facts)

save(quick_facts, file="../../data/quick_facts.RData", compress='xz')
