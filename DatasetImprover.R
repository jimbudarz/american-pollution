## This script loads the nationwide pollution data and adds information that is useful to me:
library(dplyr)
library(tidyr)
library(ggmap)
library(censusapi)

df = read.csv("pollution_us_2000_2016.csv", header = TRUE)
mycensuskey = "8d1c885da552038d22b3e2f10785a819bf822261"

# Get U.S. census data to extract populations for each city of interest:
popestimate <- getCensus(name = "pep/population",
                         key = mycensuskey,
                         vintage = 2016,
                         vars = c("POP", "GEONAME", "DATE_DESC"),
                         region = "place:*")
popestimate$City_State = gsub(' city', '', popestimate$GEONAME)

# Remove any incomplete entries:
df = df %>% filter(complete.cases(.))

# Remove locations "not in a city":
df = df %>% filter(!(City == 'Not in a city'))
df$Date.Local = as.xts(df$Date.Local)

# Average all data down to a city level:
df = df %>%
  group_by(City, Date.Local) %>%
  summarise(
    State = first(State), County = first(County),
    NO2.Units = first(NO2.Units), NO2.Mean = mean(NO2.Mean), NO2.AQI = mean(NO2.AQI),
    O3.Units = first(O3.Units), O3.Mean = mean(O3.Mean), O3.AQI = mean(O3.AQI),
    SO2.Units = first(SO2.Units), SO2.Mean = mean(SO2.Mean), SO2.AQI = mean(SO2.AQI),
    CO.Units = first(CO.Units), CO.Mean = mean(CO.Mean), CO.AQI = mean(CO.AQI)
  )

# Assign each date a month
df <- df %>%
  mutate(measurementyear = year(Date.Local),
         month = factor(months(Date.Local),
                        levels = c('January','February','March','April','May','June','July',
                                   'August','September','October','November','December')
         )
  )

# Fetch location (lat, long) information for every city:
# To limit queries, reduce list into unique set of cities:
df$City_State = paste(as.character(df$City),as.character(df$State), sep = ', ')
allCityStates = as.character(distinct(df,City_State)[["City_State"]])

citycoords = geocode(allCityStates, source = "dsk")
citycoords$City_State = as.character(distinct(df,City_State)[["City_State"]])

# Join the location into main dataset on City_State
df = inner_join(df, citycoords, by = 'City_State')

# Join population 
df = inner_join(df, popestimate, by = "City_State")

# Find number of measurements for each location:
df %>% group_by(City) %>%
  summarize(NumberOfMeasurements = n())

# Convert measurements to a common unit:


# Assign AQI labels to numeric values:
df$NO2.AQItext = cut(df$NO2.AQI,
                     breaks = c(0,50,100,150,200,300,500),
                     labels = c('Good','Moderate',
                                'Unhealthy for Sensitive Groups',
                                'Unhealthy','Very Unhealthy','Hazardous'))
df$CO.AQItext = cut(df$CO.AQI,
                    breaks = c(0,50,100,150,200,300,500),
                    labels = c('Good','Moderate',
                               'Unhealthy for Sensitive Groups',
                               'Unhealthy','Very Unhealthy','Hazardous'))
df$SO2.AQItext = cut(df$SO2.AQI,
                     breaks = c(0,50,100,150,200,300,500),
                     labels = c('Good','Moderate',
                                'Unhealthy for Sensitive Groups',
                                'Unhealthy','Very Unhealthy','Hazardous'))
df$O3.AQItext = cut(df$O3.AQI,
                    breaks = c(0,50,100,150,200,300,500),
                    labels = c('Good','Moderate',
                               'Unhealthy for Sensitive Groups',
                               'Unhealthy','Very Unhealthy','Hazardous'))

# Remove strange data before 2001:
# azdata <- azdata %>% filter(year(Date.Local) > 2001)

# Treat each pollutant measurement as a different observation:
# df <- df %>% gather(., "Pollutant", "Concentration", c('NO2.Mean', 'CO.Mean', 'SO2.Mean', 'O3.Mean'))
# df <- df %>% gather(., "Pollutant", "AQI", c('NO2.AQI', 'CO.AQI', 'SO2.AQI', 'O3.AQI'))

# Save the file at the very end:
write.csv(df, file = "PreppedPollutionData.csv")