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
denoted **South** can be viewed as such:

```
data(census_regions)
subset(census_regions, region == "South")

   region           division state
22  South East South Central    AL
23  South East South Central    KY
24  South East South Central    MS
25  South East South Central    TN
26  South     South Atlantic    DC
27  South     South Atlantic    DE
28  South     South Atlantic    FL
29  South     South Atlantic    GA
30  South     South Atlantic    MD
31  South     South Atlantic    NC
32  South     South Atlantic    SC
33  South     South Atlantic    VA
34  South     South Atlantic    WV
35  South West South Central    AR
36  South West South Central    LA
37  South West South Central    OK
38  South West South Central    TX
```
