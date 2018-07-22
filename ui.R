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
  dashboardPage(skin = "black",
                
                dashboardHeader(title  = 'American Pollution'),
                
                dashboardSidebar(
                  sidebarMenu(
                    #sidebarUserPanel("James Budarz"),
                    menuItem("Pollution Maps", tabName = "maps", icon = icon("map")),
                    selectizeInput("yearselected", "Select Year", sort(yearsavailable)),
                    selectizeInput("stateselected", "Select State", choices = NULL),
                    selectizeInput("pollutantselected", "Select Pollutant", pollutantsavailable),
                    
                    menuItem("Local Pollution History", tabName = "city", icon = icon("calendar")),
                    selectizeInput('cityselected', 'Select City', citiesavailable)
                  )
                ),
                
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "maps",
                            fluidRow(
                              column(width = 6,
                                     box(
                                       leafletOutput("pollutionmap"),
                                       width = '50%'
                                     )
                              ),
                              column(width = 6,
                                     box(plotOutput('popscatter'),
                                       width = '50%'
                                     )
                              )
                            ),
                            box(
                              plotOutput('citycompare'),
                              width = '50%'
                            )
                    ),
                    tabItem(tabName = "city",
                            fluidRow(
                              box(
                                plotlyOutput("timeplot"),
                                width = '100%'
                              )
                            ),
                            fluidRow(
                              box(
                                valueBoxOutput('NumHighDays_NO2', width = 3),
                                valueBoxOutput('NumHighDays_O3', width = 3),
                                valueBoxOutput('NumHighDays_CO', width = 3),
                                valueBoxOutput('NumHighDays_SO2', width = 3)
                              )
                            )
                    )
                  )
                )
  )
)
)