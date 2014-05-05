\docType{data}
\name{counties}
\alias{counties}
\title{2010 FIPS Codes for Counties and County-Equivalent Entities}
\format{A data frame with 3235 rows and 6 variables}
\usage{
data(counties)
}
\description{
A dataset containing state and county FIPS codes for U.S.
counties and county-equivalent entities (CEE) along with
county-level demographic data. The CEE includes non-state
locations, such as Puerto Rico (PR) and Guam (GU).
}
\details{
\itemize{ \item state. State Postal Code \item state_fips.
State FIPS Code \item county_fips. County FIPS Code \item
county_name. County Name and Legal/Statistical Area
Description \item fips_class. FIPS Class Code \item
population. County population from 2010 Census }

The following details about FIPS Class Codes have been
blatantly taken from the Census Bureau's website:

\itemize{ \item H1. Identifies an active county or
statistically equivalent entity that does not qualify under
subclass C7 or H6.  \item H4. Identifies a legally defined
inactive or nonfunctioning county or statistically
equivalent entity that does not qualify under subclass H6.
\item H5. Identifies census areas in Alaska, a statistical
county equivalent entity.  \item H6. Identifies a county or
statistically equivalent entity that is areally coextensive
or governmentally consolidated with an incorporated place,
part of an incorporated place, or a consolidated city.
\item C7: Identifies an incorporated place that is an
independent city; that is, it also serves as a county
equivalent because it is not part of any county, and a
minor civil division (MCD) equivalent because it is not
part of any MCD. }

For more details, see:
\url{http://www.census.gov/geo/reference/codes/cou.html}
}
\keyword{datasets}

