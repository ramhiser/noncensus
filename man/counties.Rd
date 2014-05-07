\docType{data}
\name{counties}
\alias{counties}
\title{Data for U.S. Counties and County-Equivalent Entities}
\format{A data frame with 3235 rows and 6 variables}
\usage{
data(counties)
}
\description{
Data containing state and county FIPS codes for U.S.
counties and county-equivalent entities (CEE) along with
county-level demographic data. The CEE includes non-state
locations, such as Puerto Rico (PR) and Guam (GU).
}
\details{
\itemize{ \item county_name. County Name and
Legal/Statistical Area Description \item state. State
Postal Code \item state_fips. State FIPS Code \item
county_fips. County FIPS Code \item fips_class. FIPS Class
Code \item CSA. Combined Statistical Area \item CBSA.
Core-based Statistical Area \item population. County
population from 2010 Census }

The U.S. Census Bureau groups counties into CSAs and CBSAs
primarily based on county population. We provide listings
of both in \code{\link[noncensus]{combined_areas}} and
\code{\link[noncensus]{corebased_areas}}.

For a detailed description, Wikipedia has excellent
discussions of both areas:
\url{http://en.wikipedia.org/wiki/Combined_Statistical_Area}
and
\url{http://en.wikipedia.org/wiki/Core_Based_Statistical_Area}.
Also, the following map from Wikipedia is excellent to
visualize the areas:
\url{http://upload.wikimedia.org/wikipedia/commons/7/7b/Combined_statistical_areas_of_the_United_States_and_Puerto_Rico.gif}

NOTE: Not all counties are members of a CSA or CBSA.

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

