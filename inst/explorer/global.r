library(shiny)
library(noncensus)
library(leaflet)
library(dplyr)
library(RColorBrewer)


data(quick_facts)


data(county_polygons)
comp_two <- left_join(county_polygons, quick_facts, by = "fips")
comp_two <- comp_two %>% arrange(group, order)

full_names <- c(
"Population, 2013 estimate",
"Population, 2010 (April 1) estimates base",
"Population, percent change from April 1, 2010 to July 1, 2013",
"Population, 2010",
"Percentage of persons under 5 years",
"Percentge of persons under 18 years",
"Percentage of persons 65 years and over",
"Percentage of Female persons",
"Percentage of Male persons",
"Percentage of persons identifying as White alone, not Hispanic or Latino",
"Percentage of persons identifying as Black or African American alone",
"Percentage of persons identifying as American Indian and Alaska Native alone",
"Percentage of persons identifying as Asian alone",
"Percentage of persons identifying as Native Hawaiian and Other Pacific Islander alone",
"Percentage of persons identifying as Two or More Races",
"Percentage of persons identifying as Hispanic or Latino",
"Percentage of persons living in the same house 1 year & over",
"Percentage of foreign born persons",
"Percentage of non-foreign born persons",
"Percentage of persons age 5+ who speak a language other than English at home",
"Percentage of persons age 5+ who speak only English at home",
"Percentage of persons age 25+ without a high school degree",
"Percentage of persons age 25+ with a high school degree or higher",
"Percentage of persons age 25+ with a Bachelor's degree or higher",
"Number of veterans",
"Mean travel time to work in minutes, workers age 16+",
"Number of housing units",
"Homeownership rate",
"Percentage of housing units in multi-unit structures",
"Median value of owner-occupied housing units",
"Number of households",
"Persons per household",
"Per capita money income in past 12 months",
"Median household income",
"Percentage of persons below poverty level",
"Number of private nonfarm establishments",
"Private nonfarm employment",
"Percent change in private nonfarm employment",
"Number of nonemployer establishments",
"Total number of firms",
"Percentage of Black-owned firms",
"Percentage of American Indian- and Alaska Native-owned firms",
"Percentage of Asian-owned firms",
"Percentage of Native Hawaiian- and Other Pacific Islander-owned firms",
"Percentage of Hispanic-owned firms",
"Percentage of Woman-owned firms",
"Manufacturers shipments, in thousands of dollars",
"Merchant wholesaler sales, in thousands of dollars",
"Retail sales, in thousands of dollars",
"Retail sales per capita",
"Accommodation and food services sales, in thousands of dollars",
"Number of building permits",
"Land area in square miles",
"Population per square mile")

level2_names <- list("Population" = c("Population estimates", 
                                      "Population per square mile", 
                                      "Age", "Gender", 
                                      "Race", "Foreign-births", "Language", 
                                      "Education", "Number of veterans"), 
                     "Housing" = c("Number of housing units",
                                   "Percentage of persons living in the same house 1 year & over",
                                   "Homeownership rate",
                                   "Percentage of housing units in multi-unit structures",
                                   "Median value of owner-occupied housing units",
                                   "Number of households",
                                   "Persons per household", 
                                   "Number of building permits",
                                   "Land area in square miles", 
                                   "Mean travel time to work in minutes, workers age 16+"), 
                     "Income" = c("Per capita money income in past 12 months",
                                  "Median household income",
                                  "Percentage of persons below poverty level"), 
                     "Employment" = c("Number of private nonfarm establishments",
                                      "Private nonfarm employment",
                                      "Percent change in private nonfarm employment",
                                      "Number of nonemployer establishments",
                                      "Number of firms"), 
                     "Sales" = c("Manufacturers shipments, in thousands of dollars",
                                 "Merchant wholesaler sales, in thousands of dollars",
                                 "Retail sales, in thousands of dollars",
                                 "Retail sales per capita",
                                 "Accommodation and food services sales, in thousands of dollars"))

level3_names <- list("Population estimates" = 
                       c("Population, 2010", 
                         "Population, percent change from April 1, 2010 to July 1, 2013",
                         "Population, 2010 (April 1) estimates base", 
                         "Population, 2013 estimate"), 
                     "Age" = c("Percentage of persons under 5 years",
                               "Percentage of  persons under 18 years",
                               "Percentage of persons 65 years and over"), 
                     "Gender" = c("Percentage of Female persons", 
                                  "Percentage of Male persons"), 
                     "Race" = c("Percentage of persons identifying as Black or African American alone",
                                "Percentage of persons identifying as American Indian and Alaska Native alone",
                                "Percentage of persons identifying as Asian alone",
                                "Percentage of persons identifying as Native Hawaiian and Other Pacific Islander alone",
                                "Percentage of persons identifying as Hispanic or Latino",
                                "Percentage of persons identifying as White alone, not Hispanic or Latino",
                                "Percentage of persons identifying as Two or More Races"), 
                     "Foreign-births" = c("Percentage of foreign born persons",
                                          "Percentage of non-foreign born persons"), 
                     "Language" = c("Percentage of persons age 5+ who speak a language other than English at home",
                                    "Percentage of persons age 5+ who speak only English at home"), 
                     "Education" = c("Percentage of persons age 25+ without a high school degree",
                                     "Percentage of persons age 25+ with a high school degree or higher",
                                     "Percentage of persons age 25+ with a Bachelor's degree or higher"),
                     "Number of firms" = c("Total number of firms",
                                           "Percentage of Black-owned firms",
                                           "Percentage of American Indian- and Alaska Native-owned firms",
                                           "Percentage of Asian-owned firms",
                                           "Percentage of Native Hawaiian- and Other Pacific Islander-owned firms",
                                           "Percentage of Hispanic-owned firms",
                                           "Percentage of Woman-owned firms"))


quick_facts$percent_male <- 1 - quick_facts$percent_female
quick_facts$percent_nonforeign <- 1 - quick_facts$percent_foreign
quick_facts$percent_English <- 1 - quick_facts$percent_nonEnglish
quick_facts$percent_nograd <- 1 - quick_facts$percent_high_school_grad

quick_facts <- cbind(quick_facts %>% select(fips, population_2013, population_2010_base, 
                                      population_change_percent, population_2010, 
                                      percent_under_5, percent_under_18, 
                                      percent_over_65, percent_female, percent_male, 
                                      percent_white_NH, percent_black, percent_native, 
                                      percent_asian, percent_hawaiian, percent_two_plus, 
                                      percent_hispanic, percent_same_house_1yr, 
                                      percent_foreign, percent_nonforeign, 
                                      percent_nonEnglish, percent_English, 
                                      percent_nograd, percent_high_school_grad, 
                                      percent_BA), quick_facts[,23:ncol(quick_facts)])

