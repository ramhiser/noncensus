\docType{data}
\name{zip_codes}
\alias{zip_codes}
\title{Data for U.S. Cities by Zip Code}
\format{A data frame with 43524 rows and 6 variables}
\usage{
data(zip_codes)
}
\description{
This data set considers each zip code throughout the U.S.
and provides additional information, including the city and
state, latitude and longitude, and the FIPS code for the
corresponding county.
}
\details{
The ZIP code data was obtained from version 1.0 of the
\code{\link[zipcode]{zipcode}} package on CRAN. The county
FIPS codes were obtained by querying the FIPS code from
each zip's latitude and longitude via the FCC's Census
Block Conversions API. For details regarding the API, see
\url{http://www.fcc.gov/developers/census-block-conversions-api}.

\itemize{ \item zip. U.S. ZIP (postal) code \item city. ZIP
code's city \item state. ZIP code's state \item latitude.
ZIP code's latitude \item longitude. ZIP code's longitude
\item fips. County FIPS Code }

The FIPS codes are useful for mapping ZIP codes and cities
to counties in the \code{\link[noncensus]{counties}} data
set.

Fun fact: ZIP is an acronym for "Zone Improvement Plan."
}
\keyword{datasets}

