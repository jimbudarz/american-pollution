# This file contains some functions to clean up the ui.R file

#Provides clear purpose and subject: Who is the target audience?
#What are the questions you are trying to answer from the dataset?
#Pertinent examples, graphs, and/or statistics;
#supports conclusions/ ideas with evidence.
#There is a conclusion summarizing the presentation.

#epaguidelinebox = box(width = 12, )

backgroundbox = box(width = 12,
  # Background of topic
  h1('Welcome!'),
  p('This app was made to help you (the concerned citizen, the policymaker, 
the environmentalist) visualize and understand the current and past states 
of air pollution in the United States.'),
  p('The first motivation for this project arose from my concerns for the 
    environment and its effect on human health.'),
  p('A note about the measurements reported in this app: The EPA has 
developed an Air Quality Index (AQI) to help explain air pollution 
levels to the general public.')
)

datasourcebox = box(width = 12,
  h2('Where did the content come from?'),
  p('The data used were obtained from 3 separate sources:'),
  p('1. Measurements of air pollutant levels for 204 measurement facilities in 105 cities 
    (https://www.kaggle.com/sogun3/uspollution)'),
  p('2. Population counts from the U.S. Census Bureau for each city, based on 2016 
estimates. They require me to us the following disclaimer: "This product uses the 
Census Bureau Data API but is not endorsed or certified by the Census Bureau."'),
  p('3. Geographical city locations determined using an API for OpenStreetMaps 
    (www.datasciencetoolkit.org/about)')
)

questionsbox = box(width = 12,
  # Identify the questions
  h3('Which cities and which areas of the country are most polluted?
     The least?'), # (Map controlled by slider selecting year)
  p('This is an obvious first question to ask. The answer depends on several
    factors: what year is of interest to you? Pollution levels change 
    over time, and data isn\'t always available for every city. Even 
    for cities where data is available it may be irregular, incomplete, 
    or missing for months or years on end. You may also be more 
    interested in some pollutants than others. Different cities experience
    pollution from different sources.'),
  p(strong("To explore this question, navigate to the 'Pollution Maps' tab and take a
    look at the U.S. map. You can select a specific year and a specific pollutant.
    While looking at the whole U.S. the bottom will display a box plot of the cities
    with the loweest pollution during that year. Select a specific state and the
    box plots will show all cities in that state with data available.")), 
  
  h3('How does city population (density) affect pollution levels?'),
  p("This is complicated. We might expect that human-caused pollution will be 
    greatest where humans are concentrated. Check out the population vs. pollutant
    scatter plot to the right of the map on the 'Pollution Maps' tab."),
  p(strong('As you soon see, there is a trend that as the population of a city 
           increases, the concentration of NO2 and CO increase. However, this 
           relationship is reversed for O3 and SO2.')),
  #
  h3('How does the pollution fluctuate? Are there strong trends?'),
  p('For trends over time, check out the "Local Pollution History" tab. The top 
    graph shows all the collected data over the years available (2000-2016). Here 
    you can select cities on an individual basis.'),
  p(strong('For cities with long and complete measurement histories, several trends 
           are obvious. NO2, CO, and SO2 show periodic seasonal behavior, peaking at 
           the beginning of winter. O3, on the other hand, peaks in the middle of the 
           year- the beginning of summer. Since this seasonal fluctuation is so strong, 
           it\'s difficult to see any long-term trends.')),
  
  h3('Does the increase in one pollutant correspond to the increase in another?'),
  p('It\'s important to know that pollutants come from many different sources both 
    human and natural. Some pollutants are produced by others upon contact with 
    sunlight (O3 from NO2, for example.'),
  p(strong('This is a good opportunity to consult the correlation plot, which follows 
           what we saw in the graph of pollutants over time. For some cities it\'s clear:
           NO2 and CO seem positively correlated, while O3 is negatively correlated with these.'))
)

whybox = box(width = 12,
  # Why should someone care
  h3("Quick rundown of common pollutants:"),
  img(src = 'aqiguidepm.png', width = '100%' ),
  p("Nitrogen Dioxide (NO2): Chronic exposure to NO2 can cause airway inflammation 
in healthy people and increased respiratory symptoms in people with asthma."),
  p("Ozone (O3): Ozone is a respiratory irritant and has been linked to many 
    lung-related disorders (https://www.epa.gov/ozone-pollution-and-your-patients-health)"),
  p('Carbon Monoxide (CO): This is produced mainly from manmade sources. It is mainly 
    linked to acute, not chronic health problems.'),
  p('Sulfur Dioxide (SO2): Sulfur dioxide emissions are a precursor to 
acid rain and atmospheric particulates, and as such great efforts have been made to 
    reduce its production in power plants.')
)
