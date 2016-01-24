#' U.S. Census Region and Demographic Data
#'
#' The R package \code{noncensus} provides a collection of various regional
#' information determined by the U.S. Census Bureau along with demographic
#' data. We have also included scripts to download, process, and load the
#' original data from their sources.
#'
#' @docType package
#' @name noncensus
#' @aliases noncensus package-noncensus
NULL

#' Demographic Data and Census Regions of U.S. States and Territories
#' 
#' A dataset containing demographic information and the census regions of each
#' U.S. state as defined by the U.S. Census Bureau. Also included are the
#' U.S. territories, such as Puerto Rico and Guam.
#'
#' The variables included are:
#'
#' \itemize{
#'   \item state. State abbreviation
#'   \item name. State name
#'   \item region. Region as defined by the U.S. Census Bureau
#'   \item division. Subregion as defined by the U.S. Census Bureau
#'   \item capital. Capital city.
#'   \item area. Land area in square miles
#'   \item population. Population from 2010 Census
#' }
#' 
#' The U.S. is divided into four regions:
#'
#' \enumerate{
#'   \item Midwest
#'   \item Northeast
#'   \item South
#'   \item West
#' }
#'
#' Within each region, states are further partitioned into divisions. For more
#' details about census regions, see:
#' \url{http://en.wikipedia.org/wiki/List_of_regions_of_the_United_States#Census_Bureau-designated_regions_and_divisions}
#'
#' Much of the state data was extracted from
#' \url{http://www.census.gov/popest/data/state/totals/2013/index.html}
#' 
#' @docType data
#' @keywords datasets
#' @name states
#' @usage data(states)
#' @format A data frame with 56 rows and 7 variables
NULL

#' Data for U.S. Counties and County-Equivalent Entities
#'
#' Data containing state and county FIPS codes for U.S. counties and
#' county-equivalent entities (CEE) along with county-level demographic
#' data. The CEE includes non-state locations, such as Puerto Rico (PR) and Guam
#' (GU).
#'
#' \itemize{
#'   \item county_name. County Name and Legal/Statistical Area Description
#'   \item state. State Postal Code
#'   \item state_fips. State FIPS Code
#'   \item county_fips. County FIPS Code
#'   \item fips_class. FIPS Class Code
#'   \item CSA. Combined Statistical Area
#'   \item CBSA. Core-based Statistical Area
#'   \item population. County population from 2010 Census
#' }
#'
#' The U.S. Census Bureau groups counties into CSAs and CBSAs primarily based on
#' county population. We provide listings of both in
#' \code{\link[noncensus]{combined_areas}} and
#' \code{\link[noncensus]{corebased_areas}}.
#'
#' For a detailed description, Wikipedia has excellent discussions of both
#' areas: \url{http://en.wikipedia.org/wiki/Combined_Statistical_Area} and
#' \url{http://en.wikipedia.org/wiki/Core_Based_Statistical_Area}.  Also, the
#' following map from Wikipedia is excellent to visualize the areas:
#' \url{http://upload.wikimedia.org/wikipedia/commons/7/7b/Combined_statistical_areas_of_the_United_States_and_Puerto_Rico.gif}
#'
#' NOTE: Not all counties are members of a CSA or CBSA.
#'
#' The following details about FIPS Class Codes have been blatantly taken from
#' the Census Bureau's website:
#'
#' \itemize{
#'   \item H1. Identifies an active county or statistically equivalent entity that does not qualify under subclass C7 or H6.
#'   \item H4. Identifies a legally defined inactive or nonfunctioning county or statistically equivalent entity that does not qualify under subclass H6.
#'   \item H5. Identifies census areas in Alaska, a statistical county equivalent entity.
#'   \item H6. Identifies a county or statistically equivalent entity that is areally coextensive or governmentally consolidated with an incorporated place, part of an incorporated place, or a consolidated city.
#'   \item C7: Identifies an incorporated place that is an independent city; that is, it also serves as a county equivalent because it is not part of any county, and a minor civil division (MCD) equivalent because it is not part of any MCD.
#' }
#'
#' For more details, see:
#' \url{http://www.census.gov/geo/reference/codes/cou.html}
#' 
#' @docType data
#' @keywords datasets
#' @name counties
#' @usage data(counties)
#' @format A data frame with 3235 rows and 6 variables
NULL


#' Data for U.S. Cities by Zip Code
#'
#' This data set considers each zip code throughout the U.S. and provides
#' additional information, including the city and state, latitude and longitude,
#' and the FIPS code for the corresponding county.
#'
#' The ZIP code data was obtained from version 1.0 of the \code{\link[zipcode]{zipcode}}
#' package on CRAN. The county FIPS codes were obtained by querying the FIPS
#' code from each zip's latitude and longitude via the FCC's Census Block
#' Conversions API. For details regarding the API, see
#' \url{http://www.fcc.gov/developers/census-block-conversions-api}.
#'
#' \itemize{
#'   \item zip. U.S. ZIP (postal) code
#'   \item city. ZIP code's city
#'   \item state. ZIP code's state
#'   \item latitude. ZIP code's latitude
#'   \item longitude. ZIP code's longitude
#'   \item fips. County FIPS Code
#' }
#'
#' The FIPS codes are useful for mapping ZIP codes and cities to counties in the
#' \code{\link[noncensus]{counties}} data set.
#'
#' Fun fact: ZIP is an acronym for "Zone Improvement Plan."
#' 
#' @docType data
#' @keywords datasets
#' @name zip_codes
#' @usage data(zip_codes)
#' @format A data frame with 43524 rows and 6 variables
NULL


#' Combined Statistical Areas (CSAs)
#'
#' The U.S. Census Bureau groups counties into CSAs primarily based on county
#' population. NOTE: Not all counties are members of a CSA. For a detailed
#' description, Wikipedia has an excellent discussion:
#' \url{http://en.wikipedia.org/wiki/Combined_Statistical_Area}.  Also, the
#' following map from Wikipedia is excellent to visualize the areas:
#' \url{http://upload.wikimedia.org/wikipedia/commons/7/7b/Combined_statistical_areas_of_the_United_States_and_Puerto_Rico.gif}
#'
#' @docType data
#' @keywords datasets
#' @name combined_areas
#' @usage data(combined_areas)
#' @format A data frame with 166 rows and 2 variables.
NULL


#' Core-based Statistical Area (CBSAs)
#'
#' The U.S. Census Bureau groups counties into CBSAs primarily based on county
#' population. NOTE: Not all counties are members of a CBSA. For a detailed
#' description, Wikipedia has an excellent discussion:
#' \url{http://en.wikipedia.org/wiki/Core_Based_Statistical_Area}.  Also, the
#' following map from Wikipedia is excellent to visualize the areas:
#' \url{http://upload.wikimedia.org/wikipedia/commons/7/7b/Combined_statistical_areas_of_the_United_States_and_Puerto_Rico.gif}
#'
#' @docType data
#' @keywords datasets
#' @name corebased_areas
#' @usage data(corebased_areas)
#' @format A data frame with 917 rows and 4 variables.
NULL

#' County Population Data by Age
#' 
#' A dataset containing the population totals and percentages for each US county
#' by age of inhabitant. The variables are as follows:
#' 
#' \itemize{
#'   \item fips. FIPS code for the county  
#'   \item age_group. Age groups are in 5 year intervals 
#'   \item population. Count of people in that county in that age group
#'   \item percent. Percent of that county's total population in that age group
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name population_age
#' @usage data(population_age)
#' @format A data frame with 56574 rows and 4 variables
NULL

#' Income, Poverty, and Health Insurance in the United States
#' 
#' A dataset containing the U.S. Census QuickFacts table of frequently requested 
#' data items from various Census Bureau programs.
#' It should be noted that for "firms", "percent_female_firms", "manu_shipments", 
#' "merchant_wholesales", "retail_sales", "retail_sales_per_capita", 
#' "accom_food_sales", and "building_permits", Skagway Municipality is included 
#' with Hoonah-Angoon Census Area and Wrangell City and Borough is included with 
#' Petersburg Census Area.
#' 
#' \itemize{
#'   \item fips.  FIPS State and County code. "0" represents national total.	
#'   \item population_2013.	Population, 2013 estimate
#'   \item population_2010_base.	Population, 2010 (April 1) estimates base
#'   \item population_change_percent.	Population, percent change from April 1, 2010 to July 1, 2013
#'   \item population_2010.	Population, 2010
#'   \item percent_under_5.	Percentage of persons under 5 years
#'   \item percent_under_18. Percentge of	persons under 18 years
#'   \item percent_over_65.	Percentage of persons 65 years and over
#'   \item percent_female.	Percentage of Female persons
#'   \item percent_white.	Percentage of persons identifying as White alone
#'   \item percent_black.	Percentage of persons identifying as Black or African American alone
#'   \item percent_native.	Percentage of persons identifying as American Indian and Alaska Native alone
#'   \item percent_asian.	Percentage of persons identifying as Asian alone
#'   \item percent_hawaiian.	Percentage of persons identifying as Native Hawaiian and Other Pacific Islander alone
#'   \item percent_two_plus.	Percentage of persons identifying as Two or More Races
#'   \item percent_hispanic.	Percentage of persons identifying as Hispanic or Latino
#'   \item percent_white_NH.	Percentage of persons identifying as White alone, not Hispanic or Latino
#'   \item percent_same_house_1yr.	Percentage of persons living in the same house 1 year & over
#'   \item percent_foreign.	Percentage of foreign born persons
#'   \item percent_nonEnglish.	Percentage of persons age 5+ who speak a language other than English at home
#'   \item percent_high_school_grad.	Percentage of persons age 25+ with a high school degree or higher
#'   \item percent_BA.	Percentage of persons age 25+ with a Bachelor's degree or higher
#'   \item veterans.	Number of veterans
#'   \item mean_travel_time.	Mean travel time to work in minutes, workers age 16+
#'   \item housing_units.	Number of housing units
#'   \item homeownership.	Homeownership rate
#'   \item percent_multi_unit.	Percentage of housing units in multi-unit structures
#'   \item median_value_housing.	Median value of owner-occupied housing units
#'   \item households. Number of households
#'   \item pph.	Persons per household
#'   \item per_capita_income.	Per capita money income in past 12 months
#'   \item med_hh_income.	Median household income
#'   \item percent_poverty.	Percentage of persons below poverty level
#'   \item private_non_farm.	Number of private nonfarm establishments
#'   \item private_non_farm_employ.	Private nonfarm employment
#'   \item pnfe_percent_change.	Percent change in private nonfarm employment
#'   \item nonemployer_estab.	Number of nonemployer establishments
#'   \item firms.	Total number of firms
#'   \item percent_black_firms.	Percentage of Black-owned firms
#'   \item percent_native_firms.	Percentage of American Indian- and Alaska Native-owned firms
#'   \item percent_asian_firms.	Percentage of Asian-owned firms
#'   \item percent_hawaiian_firms.	Percentage of Native Hawaiian- and Other Pacific Islander-owned firms
#'   \item percent_hispanic_firms.	Percentage of Hispanic-owned firms
#'   \item percent_female_firms.	Percentage of Woman-owned firms
#'   \item manu_shipments.	Manufacturers shipments, in thousands of dollars
#'   \item merchant_wholesales.	Merchant wholesaler sales, in thousands of dollars
#'   \item retail_sales.	Retail sales, in thousands of dollars
#'   \item retail_sales_per_capita.	Retail sales per capita
#'   \item accom_food_sales.	Accommodation and food services sales, in thousands of dollars
#'   \item building_permits.	Number of building permits
#'   \item land_area.	Land area in square miles
#'   \item population_sq_mi.	Population per square mile
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name quick_facts
#' @usage data(quick_facts)
#' @format A data frame with 3195 rows and 52 variables
NULL


#' Polygons to Describe Each U.S. County's Geographical Shape
#'
#' Data containing the vertices to describe each U.S. county's geographical
#' shape as a polygon. Vertices are given in terms of latitude and
#' longitude. The order in which the vertices should be drawn are also given by
#' \code{order}.
#'
#' NOTE: A small number of counties have multiple groups. Typically, these
#' counties are separated into multiple polygons by, say, a body of water.
#' Example: Galveston, Texas (FIPS == 48167).
#'
#' U.S. counties are uniquely identified by a FIPS code.
#'
#' The \code{county_polygons} data frame consists of the following variables:
#' \itemize{
#'   \item order. The order in which the vertices should be drawn.
#'   \item fips. County FIPS Code
#'   \item names. Unique name to describe county.
#'   \item group. County polygon's group number.
#'   \item lat. County's latitude
#'   \item long. County's longitude
#'   \item county. The county's name.
#' }
#'
#' @docType data
#' @keywords datasets
#' @name county_polygons
#' @usage data(county_polygons)
#' @format A data frame with 91,030 rows and 7 variables
NULL


#' Polygons to Describe Each U.S. State's Geographical Shape
#'
#' Data containing the vertices to describe each U.S. state's geographical
#' shape as a polygon. Vertices are given in terms of latitude and
#' longitude. The order in which the vertices should be drawn are also given by
#' \code{order}.
#'
#' NOTE: A small number of states have multiple groups. Typically, these
#' counties are separated into multiple polygons by, say, a body of water.
#' Example: Texas (FIPS == 48).
#'
#' U.S. states are uniquely identified by a FIPS code.
#'
#' The \code{state_polygons} data frame consists of the following variables:
#' \itemize{
#'   \item order. The order in which the vertices should be drawn.
#'   \item long. States's longitude
#'   \item lat. States's latitude
#'   \item group. State polygon's group number.
#'   \item state. The states's name.
#'   \item fips. State FIPS Code
#' }
#'
#' @docType data
#' @keywords datasets
#' @name state_polygons
#' @usage data(state_polygons)
#' @format A data frame with 26,819 rows and 6 variables
NULL


#' Polygons to Describe Each Country's Geographical Shape
#'
#' Data containing the vertices to describe each country's geographical
#' shape as a polygon. Vertices are given in terms of latitude and
#' longitude. The order in which the vertices should be drawn are also given by
#' \code{order}.
#'
#' NOTE: Many countries have multiple groups. Typically, these
#' countries are separated into multiple polygons by, say, a body of water.
#' Example: United States (FIPS == US, UN code == 840).
#'
#' Countries are uniquely identified in many ways: by a FIPS code, ISO2, IS03, 
#' and by the UN code.
#'
#' The \code{world_polygons} data frame consists of the following variables:
#' \itemize{
#'   \item order. The order in which the vertices should be drawn
#'   \item long. Country's longitude
#'   \item lat. Country's latitude
#'   \item group. Country polygon's group number
#'   \item name. Unique name to describe country
#'   \item fips. Country FIPS Code
#'   \item ISO2. Country ISO2 Code
#'   \item ISO3. Country ISO3 Code
#'   \item region. Country region (continent)
#'   \item subregion. Country subregion
#'   \item UN_code. Country UN Code
#' }
#'
#' @docType data
#' @keywords datasets
#' @name world_polygons
#' @usage data(world_polygons)
#' @format A data frame with 406,940 rows and 11 variables
NULL
