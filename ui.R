#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shinydashboard)
# Define UI for application that displays information about pollution in U.S. cities
shinyUI(fluidPage(
  dashboardPage(
    
    dashboardHeader(title  = 'American Pollution'),
    
    dashboardSidebar(
      sidebarMenu(
        #sidebarUserPanel("James Budarz"),
        menuItem("Pollution Maps", tabName = "maps", icon = icon("map")),
        selectizeInput("yearselected", "Select Year", sort(yearsavailable)),
        selectizeInput("stateselected", "Select State", sort(statesavailable)),
        selectizeInput("pollutantselected", "Select Pollutant", pollutantsavailable),
        menuItem("Local Pollution History", tabName = "city", icon = icon("calendar")),
        selectizeInput('cityselected', 'Select City', citiesavailable)
      )
    ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "maps", "Map of pollution across the U.S. by year and (optionally) state",
                fluidRow(
                  column(width = 6,
                         box(
                           leafletOutput("pollutionmap"),
                           width = '50%'
                         )
                  ),
                  column(width = 6,
                         box(
                           plotOutput('citycompare'),
                           width = '50%'
                         )
                  )
                ),
                box(plotOutput('AQIvsPOP'), width = '50%')
        ),
        tabItem(tabName = "city", "History of pollution by city",
                box(htmlOutput("calendarchart"))
                )
      )
    )
  )))