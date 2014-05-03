library(datasets)

# Linked from: http://www.census.gov/popest/data/state/totals/2013/index.html
census_data <- read.csv("http://www.census.gov/popest/data/national/totals/2013/files/NST_EST2013_ALLDATA.csv",
                        header=T)

state_capitals <- c('Montgomery', 'Juneau', 'Phoenix', 'Little Rock',
                    'Sacramento', 'Denver', 'Hartford', 'Dover', 'Tallahassee',
                    'Atlanta', 'Honolulu', 'Boise', 'Springfield',
                    'Indianapolis', 'Des Moines', 'Topeka', 'Frankfort',
                    'Baton Rouge', 'Augusta', 'Annapolis', 'Boston', 'Lansing',
                    'Saint Paul', 'Jackson', 'Jefferson City', 'Helena',
                    'Lincoln', 'Carson City', 'Concord', 'Trenton', 'Santa Fe',
                    'Albany', 'Raleigh', 'Bismarck', 'Columbus', 'Oklahoma City',
                    'Salem', 'Harrisburg', 'Providence', 'Columbia', 'Pierre',
                    'Nashville', 'Austin', 'Salt Lake City', 'Montpelier',
                    'Richmond', 'Olympia', 'Charleston', 'Madison', 'Cheyenne')

state_data <- data.frame(state=state.abb,
                         name=state.name,
                         area=state.area,
                         capital=state_capitals,
                         stringsAsFactors=FALSE)
state_data$population <- as.integer(merge(state_data,
                                          census_data,
                                          by.x="name",
                                          by.y="NAME")$CENSUS2010POP)

# Additional info from:
# http://en.wikipedia.org/wiki/List_of_capitals_in_the_United_States#Insular_area_capitals
state_data <- rbind(state_data, 
                    c("AS", "American Samoa", 76.8, "Pago Pago", 55519),
                    c("GU", "Guam", 212, "Hagåtña", 159358),
                    c("MP", "Northern Mariana Islands", 179.01, "Saipan", 53833),
                    c("PR", "Puerto Rico", 3515, "San Juan", 3725789),
                    c("VI", "U.S. Virgin Islands", 133.73, "Charlotte Amalie", 106405))

state_data$state <- factor(state_data$state)

save(state_data, file="../../data/state_data.RData")
