library(shiny)
library(gsheet)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    df <-  gsheet2tbl('docs.google.com/spreadsheets/d/1tk5bX8e0OfcYcB6qndiVZ2X46m9O0Cy1H2pDRrlRoNY') %>% 
    rename(Faculty = `What Faculty are you from?`,
           GroupsTaught = `Which groups do you teach?`,
           DataPerson   = `Do you self identify as a Research Methods, Analyst, or Data science person?`,
           OpenKnow = `How would you rate your knowledge of open sciences prior to this workshop?`,
           Replicable = `What proportion of results in your field do you expect to be replicable / valid?`,
           DFrate = `To what extent do you believe researchers in your field utilise undisclosed "Researcher Degrees of Freedom" to "improve their results" (e.g. biased recruitment, optional stopping, undisclosed outlier exclusions, Hypothesising after the results are known)?`,
           DFbad = `How "bad" is using researcher degrees of freedom to improve your results?`) %>%  
    mutate(Timestamp = lubridate::mdy_hms(Timestamp),
              Faculty	     = as.factor(Faculty),
              Teach_UG     = grepl("Undergraduates", GroupsTaught),
              Teach_PG     = grepl("Postgraduates (Coursework)", GroupsTaught),
              Teach_Res    = grepl("Research Students", GroupsTaught), 
              DataPerson	 = as.factor(DataPerson),
              Replicable   = Replicable*10
            )
##### work from here, rates by faculty, difference between data people and non-data people relationship between knowledge and Replicability

      # knowledge ~ faculty
      
      # Replicability ~ faculty
      
      # Data person ~ DFrate
      
      # Corr knowledge and rDFbad
      # corr rDFBad and Replicable
  # differences
  output$knowFac <- renderPlot(ggplot(df, aes(Faculty, OpenKnow, colour = Faculty, group = Faculty)) + 
                                  geom_violin() + geom_jitter(alpha=.5) + theme_classic()
                                )
  output$replFac <- renderPlot(ggplot(df, aes(Faculty, Replicable, colour = Faculty, group = Faculty)) + 
                                 geom_violin() + geom_jitter(alpha=.5) + theme_classic()
  )
  
  output$DPDFrate <- renderPlot(ggplot(df, aes(DataPerson, DFrate, colour = DataPerson, group = DataPerson)) + 
                                 geom_violin() + geom_jitter(alpha=.5) + theme_classic()
  )
  
  # relationships
  output$knowbad <- renderPlot(ggplot(df, aes(OpenKnow, DFbad)) + 
                                 geom_point() + geom_smooth(method="lm", se = FALSE) +  
                                 theme_classic()
                               )
  output$BadRepl <- renderPlot(ggplot(df, aes(DFbad, Replicable)) + 
                                 geom_point() + geom_smooth(method="lm", se = FALSE) +  
                                 theme_classic()
  )  
     
})
