\docType{data}
\name{states}
\alias{states}
\title{Demographic Data and Census Regions of U.S. States and Territories}
\format{A data frame with 56 rows and 7 variables}
\usage{
data(states)
}
\description{
A dataset containing demographic information and the census
regions of each U.S. state as defined by the U.S. Census
Bureau. Also included are the U.S. territories, such as
Puerto Rico and Guam.
}
\details{
The variables included are:

\itemize{ \item state. State abbreviation \item name. State
name \item region. Region as defined by the U.S. Census
Bureau \item division. Subregion as defined by the U.S.
Census Bureau \item capital. Capital city.  \item area.
Land area in square miles \item population. Population from
2010 Census }

The U.S. is divided into four regions:

\enumerate{ \item Midwest \item Northeast \item South \item
West }

Within each region, states are further partitioned into
divisions. For more details about census regions, see:
\url{http://en.wikipedia.org/wiki/List_of_regions_of_the_United_States#Census_Bureau-designated_regions_and_divisions}

Much of the state data was extracted from
\url{http://www.census.gov/popest/data/state/totals/2013/index.html}
}
\keyword{datasets}

