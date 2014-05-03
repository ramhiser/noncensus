# 2010 FIPS Codes for Counties and County Equivalent Entities
# Details from census.gov:
# http://www.census.gov/geo/reference/codes/cou.html
col_names <- c("state", "state_fips", "county_fips", "county_name", "fips_class")
col_classes <- c("factor", "factor", "character", "character", "factor")
county_fips <- read.csv("http://www.census.gov/geo/reference/codes/files/national_county.txt",
                        header=T,
                        col.names=col_names,
                        colClasses=col_classes)

save(county_fips, file="../../data/county_fips.RData")
