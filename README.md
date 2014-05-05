# noncensus

The R package `noncensus` provides a collection of various regional information
determined by the U.S. Census Bureau along with demographic data.

## Installation

You can install the latest package version by typing the following at the R
console:

```
library(devtools)
install_github('noncensus', 'ramhiser')
```

## Usage

Once you have installed and loaded the `noncensus` package, you can load a data
set with the `data` command. For instance, U.S. states in the region
denoted **West** can be viewed as such:

```
data(states)
subset(states, region == "West")

   state       name region division        capital   area population
1     AK     Alaska   West  Pacific         Juneau 589757    4779736
4     AZ    Arizona   West Mountain        Phoenix 113909    2915918
5     CA California   West  Pacific     Sacramento 158693   37253956
6     CO   Colorado   West Mountain         Denver 104247    5029196
12    HI     Hawaii   West  Pacific       Honolulu   6450    1360301
14    ID      Idaho   West Mountain          Boise  83557   12830632
27    MT    Montana   West Mountain         Helena 147138     989415
33    NM New Mexico   West Mountain       Santa Fe 121666   19378102
34    NV     Nevada   West Mountain    Carson City 110540    9535483
38    OR     Oregon   West  Pacific          Salem  96981    3831074
45    UT       Utah   West Mountain Salt Lake City  84916    2763885
48    WA Washington   West  Pacific        Olympia  68192    6724540
51    WY    Wyoming   West Mountain       Cheyenne  97914     563626
```

## Roadmap

### Version 0.2

- More detailed demographic data (discussion below)
- Similar to the [UScensus2010
  package](http://cran.r-project.org/web/packages/UScensus2010/index.html) but
  awesomer

The demographic data included in version 0.1 was limited to aggregate
information for a given geographic area (i.e., county, state). The U.S. Census
Bureau breaks this demographic data down into specific groups: 18 different age
groups, specific ethnicity cohorts, and gender. Furthermore, the Bureau
provides the actual data from the 2010 census and annual estimates for the
subsequent years.

The detailed data are provided by the U.S. Census Bureau
[here](http://www.census.gov/popest/data/index.html). In version 0.2 we should
include all  of the data and a simple API so that the data are easily
accessible.

### Version 0.3

- Data exploration and visualization
- Simple API to correlate city- or county-level spatial data with census data
- Focus on cholorpleths and standard spatial models
- Possily work with spatial data frames to utilize existing packages.
  - Should be simple and easy to use
  - Minimal boilerplate code for data munging and massaging
  - Existing work described in the [spatial CRAN Task View](http://cran.r-project.org/web/views/Spatial.html)
