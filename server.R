#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
source('helper.R')

HazLevels <- data.frame(ystart = c(0,50,100,150,200,300),
                        yend = c(50,100,150,200,300,500),
                        HazColors = c('green','yellow','orange','red','purple','maroon'))

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  isolate({
    withProgress({
      setProgress(message = "Loading...")
    })})
  
  possibleStates <- reactive({
    stateList = df %>%
      filter(measurementyear == input$yearselected) %>%
      select(State) %>%
      unique() %>%
      arrange(State) %>%
      rbind(data.frame(State = 'ALL'),.)
    stateList$State
  })
  
  observe({
    updateSelectizeInput(session, "stateselected",
                         choices = possibleStates(),
                         selected = possibleStates()[1],
                         server = TRUE)
  })
  
  AQI_byPollutantYear <- reactive({
    AnnualCityAQI %>% 
      filter(PollutantType == input$pollutantselected &
               measurementyear == input$yearselected)
  })
  
  df_CurrentCity <- reactive({
    #df$Date.Local = as.xts(df$Date.Local)
    df %>% filter(input$cityselected == City_State) %>%
      select(City, Date.Local, NO2, O3, SO2, CO, measurementyear, month, City_State, lon, lat)
  })
  
  #daysAvailableCurrentCity <- reactive({
  #  #df$Date.Local = as.xts(df$Date.Local)
  #  df_CurrentCity() %>% n()
  #})
  
  output$NumHighDays_NO2 <- renderValueBox({
    daysOverCurrentCity = df_CurrentCity() %>%
      filter(., NO2 >= 51) %>%
      count()
    daysAvailableCurrentCity = df_CurrentCity() %>%
      count()
    valueBox(round(365 * daysOverCurrentCity[[1]] / daysAvailableCurrentCity[[1]]),
             "Days of Moderate/High NO2 Level Per Year")
  })
  
  output$NumHighDays_O3 <- renderValueBox({
    daysOverCurrentCity = df_CurrentCity() %>%
      filter(., O3 >= 51) %>%
      count()
    daysAvailableCurrentCity = df_CurrentCity() %>%
      count()
    valueBox(round(365 * daysOverCurrentCity[[1]] / daysAvailableCurrentCity[[1]]),
             "Days of Moderate/High O3 Level Per Year")
  })
  
  output$NumHighDays_CO <- renderValueBox({
    daysOverCurrentCity = df_CurrentCity() %>%
      filter(., CO >= 51) %>%
      count()
    daysAvailableCurrentCity = df_CurrentCity() %>%
      count()
    valueBox(round(365 * daysOverCurrentCity[[1]] / daysAvailableCurrentCity[[1]]),
             "Days of Moderate/High CO Level Per Year")
  })
  output$NumHighDays_SO2 <- renderValueBox({
    daysOverCurrentCity = df_CurrentCity() %>%
      filter(., SO2 >= 51) %>%
      count()
    daysAvailableCurrentCity = df_CurrentCity() %>%
      count()
    valueBox(round(365 * daysOverCurrentCity[[1]] / daysAvailableCurrentCity[[1]]),
             "Days of Moderate/High SO2 Level Per Year")
  })
  
  #output$WorstMonth <- renderValueBox({
  #  valueBox(
  #    df_CurrentCity() %>%
  #      group_by(month) %>%
  #      summarize(MeanAQI = mean(input$pollutantselected)) %>%
  #      arrange(desc(MeanAQI)) %>%
  #      top_n(1) %>%
  #      select(month),
  #    'Worst Month'
  #    )
  # })
  
  # Timeseries:
  output$timeplot <- renderPlotly({
    x <- list(
      title = "Date"
    )
    y <- list(
      title = "AQI"
    )
    
    
    plot_ly(df_CurrentCity()) %>%
      add_markers(x = ~Date.Local, y = ~NO2, name = "NO2") %>%
      add_markers(x = ~Date.Local, y = ~O3, name = "O3") %>%
      add_markers(x = ~Date.Local, y = ~CO, name = "CO") %>%
      add_markers(x = ~Date.Local, y = ~SO2, name = "SO2") %>%
      add_lines(x = c(-Inf, Inf), y = c(50, 50)) %>%
      add_lines(x = c(-Inf, Inf), y = c(100, 100)) %>% 
      layout(xaxis = x, yaxis = y)
  })
    #renderGvis({
    #gvisAreaChart(df_CurrentCity(),
    #  xvar = "Date.Local",
    #  yvar = c('NO2','O3','CO','SO2')
    #)
  #})
    
  # Calendar plot of AQI for a single city:
  output$calendarchart <- renderGvis({
    gvisCalendar(df_CurrentCity(),
                 datevar = "Date.Local",
                 numvar = input$pollutantselected,
                 chartid = "Calendar"
    )
  })
  output$popscatter = renderPlot({
    currstateonly = AQI_byPollutantYear() %>% filter(state == input$stateselected)
    
    ggplot(AQI_byPollutantYear()) +
      geom_point(aes(x = citypop, y = AQI)) +
      scale_x_log10() +
      geom_smooth(aes(x = citypop, y = AQI),method = 'lm') +
      geom_point(data = currstateonly, aes(x = citypop, y = AQI), color = 'blue', size = 6) +
      ggtitle('Effect of City Size on Pollution') + 
      xlab('City Population') +
      ylab(paste("Air Quality Index for",input$pollutantselected)) +
      theme_minimal()
  })
  
  # Boxplots comparing different cities in the same state:
  output$citycompare <- renderPlot({
    
    if (input$stateselected != "ALL") {
      
      newdf = df %>%
        filter(measurementyear == input$yearselected & State == input$stateselected) #%>%
        #mutate(City, pollutantOfInterest = input$pollutantselected)
      
      max_y = newdf %>% select(input$pollutantselected) %>% max()
      
      ggplot(newdf) +
        geom_boxplot(data = newdf,
                     aes_string(x = paste0("reorder(City, ",input$pollutantselected,")"),
                                y = input$pollutantselected)) +
        geom_rect(data = HazLevels,
                  aes(xmin = -Inf, xmax = Inf,
                      ymin = ystart, ymax = yend),
                  fill = HazLevels$HazColors,
                  alpha = 0.3) + 
        labs(x = "City") +
        theme_minimal() + 
        coord_cartesian(expand = TRUE, ylim = c(0, max_y)) + 
        ggtitle("Pollution Levels Across the State")
    }
  })
  
  # Map showing pollution bubbles
  output$pollutionmap <- renderLeaflet({
    
    AQI_byPollutantYear = AQI_byPollutantYear() %>%
      filter(ifelse(input$stateselected == 'ALL', T, state == input$stateselected))
    
    pal <- colorNumeric(palette = "Reds", domain = AQI_byPollutantYear$AQI)
    
    AQI_byPollutantYear %>%
      leaflet() %>% addProviderTiles('OpenTopoMap', group = "Topo") %>%
      addCircleMarkers(lng = AQI_byPollutantYear$long, lat = AQI_byPollutantYear$lat,
                       label = paste(AQI_byPollutantYear$City_State, '<br>',
                                   'Population:', AQI_byPollutantYear$citypop, '<br>',
                                   'Average Annual AQI:', round(AQI_byPollutantYear$AQI)),
                       fillColor = 'Red',
                       opacity = AQI_byPollutantYear$AQI/max(AQI_byPollutantYear$AQI),
                       fillOpacity = AQI_byPollutantYear$AQI/max(AQI_byPollutantYear$AQI),
                       radius = 20 * sqrt(AQI_byPollutantYear$citypop/max(AQI_byPollutantYear$citypop, na.rm = T)),
                       color = 'Red',
                       stroke = F) #%>%
      #addLegend("bottomright", pal = pal, values = AQI_byPollutantYear$PollutantType, title = "AQI")
    #   0 to 50 	Good 	Green
    # 51 to 100 	Moderate 	Yellow
    #101 to 150 	Unhealthy for Sensitive Groups 	Orange
    #151 to 200 	Unhealthy 	Red
    #201 to 300 	Very Unhealthy 	Purple
    #301 to 500 	Hazardous 	Maroon
  })
})
