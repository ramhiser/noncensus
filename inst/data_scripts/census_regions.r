# For info about census regions, see:
# http://en.wikipedia.org/wiki/List_of_regions_of_the_United_States#Census_Bureau-designated_regions_and_divisions

# Region - Midwest

# Division - East North Central
east_north_central <- data.frame(
    region="Midwest",
    division="East North Central",
    state=c("IL", "IN", "MI", "OH", "WI")
)

# Division - West North Central
west_north_central <- data.frame(
    region="Midwest",
    division="West North Central",
    state=c("IA", "KS", "MN", "MO", "ND", "NE", "SD")
)

# Region - Northeast

# Division - Mid-Atlantic
mid_atlantic <- data.frame(
    region="Northeast",
    division="Mid-Atlantic",
    state=c("NJ", "NY", "PA")
)

# Division - New England
new_england <- data.frame(
    region="Northeast",
    division="New England",
    state=c("CT", "MA", "ME", "NH", "RI", "VT")
)

# Region - South

# Division - East South Central
east_south_central <- data.frame(
    region="South",
    division="East South Central",
    state=c("AL", "KY", "MS", "TN")
)

# Division - South Atlantic
south_atlantic <- data.frame(
    region="South",
    division="South Atlantic",
    state=c("DC", "DE", "FL", "GA", "MD", "NC", "SC", "VA", "WV")
)

# Division - West South Central
west_south_central <- data.frame(
    region="South",
    division="West South Central",
    state=c("AR", "LA", "OK", "TX")
)

# Region - West

# Division - Mountain
mountain <- data.frame(
    region="West",
    division="Mountain",
    state=c("AZ", "CO", "ID", "MT", "NM", "NV", "UT", "WY")
)

# Division - Pacific
pacific <- data.frame(
    region="West",
    division="Pacific",
    state=c("AK", "CA", "HI", "OR", "WA")
)

census_regions <- rbind(east_north_central,
                        west_north_central,
                        mid_atlantic,
                        new_england,
                        east_south_central,
                        south_atlantic,
                        west_south_central,
                        mountain,
                        pacific)
census_regions$region <- factor(census_regions$region)
census_regions$division <- factor(census_regions$division)
census_regions$state <- factor(census_regions$state)

save(census_regions, file="../../data/census_regions.RData")
