# american-pollution
An interactive Shiny App to visualize pollution measurements across the U.S. 

## Questions worth asking:

Are our current laws keeping us safe from harmful pollution? (For splitting data into danger vs safe zone: What are high vs. safe levels? Asthma etc. https://www.epa.gov/criteria-air-pollutants/naaqs-table)

- Which cities and which areas of the country are most polluted? The least?
**(Map controlled by slider selecting year)**

- How does city population (density) affect pollution levels?
**(Scatter plot of population vs. pollution levels, radio buttons control which pollutants are plotted)**

- How does city a compare to city b?
**(Box oplots of AQI for up to 5 selectable cities, plus Two-Sample T-Tests to indicate whether cities are significantly different)**

- How does the pollution change over the long term? Over the short term? Do all cities fluctuate similarly?
**(Time series by selection of city)**

- How do the different pollutants relate to one another? Can the variables be described as independent?
**(Correlation plot for all 4 different pollutants)**

- Challenge: Are there any remarkable events?
**(Time-series inflection points)**

## Notes on project scoring:

### Analysis

Provides clear purpose and subject: Who is the target audience? What are the questions you are trying to answer from the dataset?
Pertinent examples, graphs, and/or statistics; supports conclusions/ ideas with evidence.
There is a conclusion summarizing the presentation.

### Code
Project folder is well structured using gitignore.
Show the audience the workflow of the project.
Code quality: Effective naming (variables, functions, etc) Readability and consistency (comments, structure and layout, etc.) Efficiency (use functions efficiently, algorithms, etc.)

### Presentation
Speaker maintains good eye contact with the audience and is appropriately animated (e.g., gestures, moving around, etc.)
Speaker uses a clear, audible voice. Delivery is poised, controlled, and smooth.
Length of presentation is within the assigned time limits.
Easy to follow and informative.

Disclaimer: "This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau."