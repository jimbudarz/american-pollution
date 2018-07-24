## Load all necessary libraries
library(shiny)
library(dplyr)
library(tidyr)
library(htmltools)
library(ggplot2)
library(leaflet)
library(plotly)
library(corrplot)

## Load dataset processed by DatasetImprover.R
df = read.csv("PreppedPollutionData.csv", header = TRUE)

## Rename the Air Quality Index Columns to be more user-friendly
names(df)[names(df) == 'NO2.AQI'] <- 'NO2'
names(df)[names(df) == 'O3.AQI'] <- 'O3'
names(df)[names(df) == 'SO2.AQI'] <- 'SO2'
names(df)[names(df) == 'CO.AQI'] <- 'CO'

## Convert datestamps to date format for time series plot
df$Date.Local = as.Date(df$Date.Local)

## Make a reduced dataset for the map and scatter plot:
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

## Create lists for selectizeInput in ui.R:
yearsavailable = unique(df$measurementyear)
citiesavailable = unique(df$City_State)
pollutantsavailable = unique(AnnualCityAQI$PollutantType)