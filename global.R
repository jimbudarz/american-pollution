library(shiny)
library(dplyr)
library(tidyr)
library(htmltools)
library(ggplot2)
#library(googleVis)
library(leaflet)
#library(dygraphs)
library(plotly)
library(corrplot)


df = read.csv("PreppedPollutionData.csv", header = TRUE)

names(df)[names(df) == 'NO2.AQI'] <- 'NO2'
names(df)[names(df) == 'O3.AQI'] <- 'O3'
names(df)[names(df) == 'SO2.AQI'] <- 'SO2'
names(df)[names(df) == 'CO.AQI'] <- 'CO'
#df = mutate(df, NO2 = NO2.AQI, O3 = O3.AQI, SO2 = SO2.AQI, CO = CO.AQI)

df$Date.Local = as.Date(df$Date.Local)

cityAQI = df %>%
  group_by(City_State) %>%
  summarise(citypop = first(POP),
            lat = first(lat),
            long = first(lon),
            NO2 = mean(NO2),
            O3 = mean(O3),
            SO2 = mean(SO2),
            CO = mean(CO))

AnnualCityAQI = df %>%
  group_by(City_State, measurementyear) %>%
  summarise(citypop = first(POP),
            state = first(State),
            lat = first(lat),
            long = first(lon),
            NO2 = mean(NO2),
            O3 = mean(O3),
            SO2 = mean(SO2),
            CO = mean(CO)) %>%
  gather(key = "PollutantType",
         value = 'AQI',
         c('NO2','O3','SO2','CO')
         )

#cityAQI$City_State = as.factor(cityAQI$City_State)
yearsavailable = unique(df$measurementyear)
statesavailable = c('ALL', sort(as.character(unique(df$State)))) # NEED TO GET RID OF THIS LINE AND LIMIT TO AVAILABLE STATES PER YEAR
citiesavailable = unique(df$City_State)
pollutantsavailable = unique(AnnualCityAQI$PollutantType)