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

#' Census Regions of U.S. States
#' 
#' A dataset containing the census regions of each U.S. state as defined by the
#' U.S. Census Bureau. The U.S. is divided into four regions:
#'
#' \enumerate{
#'   \item Midwest
#'   \item Northeast
#'   \item South
#'   \item West
#' }
#'
#' Within each region, states are further partitioned into divisions. This data
#' frame provides the \code{region} and \code{division} for each U.S. State.
#'
#' For more details about census regions, see:
#' \url{http://en.wikipedia.org/wiki/List_of_regions_of_the_United_States#Census_Bureau-designated_regions_and_divisions}
#' 
#'  @docType data
#'  @keywords datasets
#'  @name census_regions
#'  @usage data(census_regions)
#'  @format A data frame with 51 rows and 3 variables
NULL
