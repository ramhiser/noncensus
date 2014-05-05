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

#' 2010 FIPS Codes for Counties and County-Equivalent Entities
#' 
#' A dataset containing state and county FIPS codes for U.S. counties and
#' county-equivalent entities (CEE) along with county-level demographic
#' data. The CEE includes non-state locations, such as Puerto Rico (PR) and Guam
#' (GU).
#'
#' \itemize{
#'   \item state. State Postal Code
#'   \item state_fips. State FIPS Code
#'   \item county_fips. County FIPS Code
#'   \item county_name. County Name and Legal/Statistical Area Description
#'   \item fips_class. FIPS Class Code
#'   \item population. County population from 2010 Census
#' }
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
#'  @docType data
#'  @keywords datasets
#'  @name counties
#'  @usage data(counties)
#'  @format A data frame with 3235 rows and 6 variables
NULL
