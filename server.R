#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
source('helper.R')
library(leaflet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # AQI vs population
  output$AQIvsPOP <- renderPlot({
    if (input$stateselected == "All") {
    ggplot(AnnualCityAQI %>% 
             filter(input$yearselected == measurementyear,
                                    input$pollutantselected == PollutantType), 
           aes(x = citypop, y = AQI)) +
      geom_point() +
      scale_x_log10() +
      geom_smooth(method = 'lm') +
      ggtitle('Effect of population on Pollution')} else {
        "Population statistics are only produced on a national basis. Please select 'All' under the 'States' menu."}
  })
  
  # Calendar plot of AQI for a single city:
  output$calendarchart <- renderGvis({
    gvisCalendar(df %>% filter(input$cityselected == City_State),
                 datevar = "Date.Local",
                 numvar = input$pollutantselected,
                 chartid = "Calendar"
    )
  })
  
  # Boxplots comparing different cities in the same state:
  output$citycompare <- renderPlot({
    if (input$stateselected != "All") {

      df %>%
        filter(measurementyear == input$yearselected & State == input$stateselected) %>%
        mutate(City, pollutantOfInterest = input$pollutantselected) %>%
      
        ggplot() +
        geom_boxplot(aes_string(x = paste0("reorder(City, ",input$pollutantselected,")"), y = input$pollutantselected))
      }
  })
  
  # Map showing pollution bubbles
  output$pollutionmap <- renderLeaflet({
    newdf = AnnualCityAQI %>% filter(PollutantType == input$pollutantselected &
                                       measurementyear == input$yearselected &
                                       ifelse(input$stateselected == 'All', T, state == input$stateselected))
    
    pal <- colorNumeric(palette = "Reds", domain = newdf$AQI)
    
    newdf %>%
      leaflet() %>% addProviderTiles('OpenTopoMap', group = "Topo") %>%
      addCircleMarkers(lng = newdf$long, lat = newdf$lat,
                       label = paste(newdf$City_State, '<br>',
                                   'Population:', newdf$citypop, '<br>',
                                   'Average Annual AQI:', round(newdf$AQI)),
                       fillColor = 'Red',
                       opacity = newdf$AQI/100,
                       fillOpacity = newdf$AQI/100,
                       radius = 20 * sqrt(newdf$citypop/max(newdf$citypop, na.rm = T)),
                       color = 'Red',
                       stroke = F) #%>%
      #addLegend("bottomright", pal = pal, values = newdf$PollutantType, title = "AQI")
    #   0 to 50 	Good 	Green
    # 51 to 100 	Moderate 	Yellow
    #101 to 150 	Unhealthy for Sensitive Groups 	Orange
    #151 to 200 	Unhealthy 	Red
    #201 to 300 	Very Unhealthy 	Purple
    #301 to 500 	Hazardous 	Maroon
  })
})
