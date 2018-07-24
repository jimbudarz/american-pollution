## Load libraries only necessary within ui.R:
library(shinydashboard)

# Define UI as adaptive page:
shinyUI(fluidPage(
  dashboardPage(skin = "black",
                dashboardHeader(title  = 'American Pollution'),
                
                dashboardSidebar(
                  sidebarMenu(
                    ## Define sidebar with all selectable options:

                    # Sidebar selections for "Pollution Maps" page
                    menuItem("Pollution Maps", tabName = "maps", icon = icon("map")),
                    selectizeInput("yearselected", "Select Year", sort(yearsavailable)),
                    selectizeInput("stateselected", "Select State", choices = NULL),
                    selectizeInput("pollutantselected", "Select Pollutant", pollutantsavailable),
                    
                    # Sidebar selections for "Local Pollution History" page
                    menuItem("Local Pollution History", tabName = "city", icon = icon("calendar")),
                    selectizeInput('cityselected', 'Select City', citiesavailable)
                  )
                ),
                ## Create dashboard body with 2 tabs: one for national/statewide averages, one for city timeseries
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "maps",
                            fluidRow(
                              column(width = 6,
                                     box(leafletOutput("pollutionmap"), width = '50%')
                              ),
                              column(width = 6, 
                                     box(plotOutput('popscatter'), width = '50%')
                              )
                            ),
                            box(
                              plotOutput('citycompare'), width = '50%')
                    ),
                    tabItem(tabName = "city",
                            fluidRow(
                              box(
                                plotlyOutput("timeplot"), width = '100%')
                            ),
                            fluidRow(
                              box(
                                plotOutput('correlationplot')
                              ),
                              box(
                                # Plot all aggregate valueBoxes to display city statistics:
                                valueBoxOutput('NumModerateDays_NO2', width = 3),
                                valueBoxOutput('NumModerateDays_O3', width = 3),
                                valueBoxOutput('NumModerateDays_CO', width = 3),
                                valueBoxOutput('NumModerateDays_SO2', width = 3),
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