library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

all_county <- read.csv("http://www.census.gov/popest/data/counties/asrh/2013/files/CC-EST2013-ALLDATA.csv", 
                       stringsAsFactors = F) 
mall_county <- melt(all_county, names(all_county)[1:7], value.name = "population")
names(mall_county)[8] <- "group"
unique_pops <- mall_county[which(mall_county$group == "NH_MALE")[1]:nrow(mall_county),]
unique_pops$hispanic <- str_detect(unique_pops$group, "^H")

names(unique_pops)[1:7] <- c("sumlev", "state_fips", "cnty_fips", "state", 
                              "county", "year", "age_group")
unique_pops <- mutate(unique_pops, fips = 1000 * state_fips + cnty_fips)

unique_pops2 <- unique_pops %>% filter(year == 1) %>% select(fips, age_group, population)
unique_pops2 <- filter(unique_pops2, age_group != 0)
unique_pops2 <- ddply(unique_pops2, c("fips"), transform, total = sum(population))

unique_pops2 <- mutate(unique_pops2, percent = population / total)

age_key <- list("0" = "Total", 
                "1" = "0 - 4", 
                "2" = "5 - 9", 
                "3" = "10 - 14", 
                "4" = "15 - 19",
                "5" = "20 - 24", 
                "6" = "25 - 29",
                "7" = "30 - 34",
                "8" = "35 - 39", 
                "9" = "40 - 44", 
                "10" = "45 - 49", 
                "11" = "50 - 54", 
                "12" = "55 - 59", 
                "13" = "60 - 64", 
                "14" = "65 - 69", 
                "15" = "70 - 74", 
                "16" = "75 - 79", 
                "17" = "80 - 84", 
                "18" = "85 or older") 

unique_pops2$age_group <- unlist(age_key[as.character(unique_pops2$age_group)])

population_age <- ddply(unique_pops2, c("fips", "age_group"), summarize, 
                        population = sum(population), percent = sum(percent))

