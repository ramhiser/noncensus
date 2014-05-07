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

We also provide data for all U.S. counties, which are uniquely identified by
[FIPS county codes](http://en.wikipedia.org/wiki/FIPS_county_code). The
`counties` data set contains all of the U.S. counties and county equivalents
along with [Combined Statistical Area
(CSA)](http://en.wikipedia.org/wiki/Combined_Statistical_Area) and [Core-Based
Statistical Area
(CSBA)](http://en.wikipedia.org/wiki/Core_Based_Statistical_Area). 

```
data(counties)
head(counties)
     county_name state state_fips county_fips fips_class  CSA  CBSA population
1 Autauga County    AL         01         001         H1 <NA> 33860      54571
2 Baldwin County    AL         01         003         H1  380 19300     182265
3 Barbour County    AL         01         005         H1 <NA>  <NA>      27457
4    Bibb County    AL         01         007         H1  142 13820      22915
5  Blount County    AL         01         009         H1  142 13820      57322
6 Bullock County    AL         01         011         H1 <NA>  <NA>      10914
```

Details about the data stored in `counties` can be obtained via `?counties`,
including details regarding CSA and CBSA. The following image [from
Wikipedia](http://en.wikipedia.org/wiki/Combined_Statistical_Area#Map)
summarizes the statistical areas well:

![U.S. Statistical Areas](http://upload.wikimedia.org/wikipedia/commons/7/7b/Combined_statistical_areas_of_the_United_States_and_Puerto_Rico.gif)

It is sometimes useful to map FIPS codes at the county level to the more
granular zip codes. However, these data are seldom available and are tedious to
come by. We provide such a mapping in `zip_codes`:

```
data(zip_codes)
head(zip_codes, 10)
     zip        city state latitude longitude  fips
1  00210  Portsmouth    NH  43.0059  -71.0132 33015
2  00211  Portsmouth    NH  43.0059  -71.0132 33015
3  00212  Portsmouth    NH  43.0059  -71.0132 33015
4  00213  Portsmouth    NH  43.0059  -71.0132 33015
5  00214  Portsmouth    NH  43.0059  -71.0132 33015
6  00215  Portsmouth    NH  43.0059  -71.0132 33015
7  03040 East Candia    NH  43.0059  -71.0132 33015
8  03041  East Derry    NH  43.0059  -71.0132 33015
9  03073 North Salem    NH  43.0059  -71.0132 33015
10 03802  Portsmouth    NH  43.0059  -71.0132 33015
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
