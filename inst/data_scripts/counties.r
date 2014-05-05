# 2010 FIPS Codes for Counties and County Equivalent Entities
# Details from census.gov:
# http://www.census.gov/geo/reference/codes/cou.html
library(dplyr)
col_names <- c("state", "state_fips", "county_fips", "county_name", "fips_class")
col_classes <- rep.int("character", times=length(col_names))
county_fips <- read.csv("http://www.census.gov/geo/reference/codes/files/national_county.txt",
                        header=T,
                        col.names=col_names,
                        colClasses=col_classes)

# County-level data from the Census Bureau
# Not included for Puerto Rico
census_data <- read.csv('http://www.census.gov/popest/data/counties/totals/2013/files/CO-EST2013-Alldata.csv',
                        header=TRUE)
# The variable SUMLEV indicates "Geographic summary level"
# 040 = State and/or Statistical Equivalent
# 050 = County and /or Statistical Equivalent
# We retain only the county data
census_data <- subset(census_data, SUMLEV == 50)

# For now, we are focused on county-level population from the 2010 census
census_data <- subset(census_data, select=c("STATE", "COUNTY", "CENSUS2010POP"))
colnames(census_data) <- c("state_fips", "county_fips", "population")

# Recode state_fips and county_fips to join against census_data
# Pads FIPS codes with the appropriate amount of 0's
census_data$state_fips <- sprintf("%02d", census_data$state_fips)
census_data$county_fips <- sprintf("%03d", census_data$county_fips)

# Merges the FIPS and Census data
# The left join induces NA for demographic/population data when not FIPS code
# not included (e.g., Puerto Rico).
counties <- left_join(county_fips, census_data)

counties$state <- factor(counties$state)
counties$state_fips <- factor(counties$state_fips)
counties$county_fips <- factor(counties$county_fips)
counties$fips_class <- factor(counties$fips_class)

save(counties, file="../../data/counties.RData")
