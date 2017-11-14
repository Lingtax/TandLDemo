library(shiny)
library(gsheet)
library(tidyverse)
library(plotly)

shinyServer(function(input, output) {
    
    df <-  gsheet2tbl("docs.google.com/spreadsheets/d/1tk5bX8e0OfcYcB6qndiVZ2X46m9O0Cy1H2pDRrlRoNY") 
    df <- df[rowSums(is.na(df)) != ncol(df), ] %>% 
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
    

  # differences
  output$knowFac <- renderPlot(ggplot(df, aes(Faculty, OpenKnow, colour = Faculty, group = Faculty)) + 
                                 coord_cartesian(ylim = c(1, 7)) + geom_violin() + geom_jitter(alpha=.5) + 
                                 labs(y = "Prior Knowledge of Open Science") + theme_classic() + 
                                 theme(axis.text.y = element_blank()) + ggtitle("Open science knowledge by Faculty")
                                )
  output$replFac <- renderPlot(ggplot(df, aes(Faculty, Replicable, colour = Faculty, group = Faculty)) + 
                                 coord_cartesian(ylim = c(0, 100)) + geom_violin() + geom_jitter(alpha=.5) +
                                 labs(y = "Estimated field Replicability / Validity") + 
                                 theme_classic() + ggtitle("Estimated Replicability of field by Faculty")
  )
  
  output$DPDFrate <- renderPlot(ggplot(df, aes(DataPerson, DFrate, colour = DataPerson, group = DataPerson)) + 
                                  coord_cartesian(ylim = c(1, 7)) + geom_violin() + geom_jitter(alpha=.5) + 
                                  labs(x = "Self Identification as a 'Data Person'", y = "Estimated rate of Researcher df exploitation") + 
                                  theme_classic() + theme(axis.text.y = element_blank()) + 
                                  ggtitle("Estimated rate of Researcher dfs by identification as 'data person'" )
  )
  
  # relationships
  output$knowbad <- renderPlotly({p1 <- ggplot(df, aes(OpenKnow, DFbad)) + 
                                 geom_point(aes(colour = Faculty, shape = DataPerson)) + geom_smooth(method="lm", se = FALSE) +  
                                 coord_cartesian(xlim = c(1, 7), ylim = c(1, 7)) + 
                                 theme_classic() + theme(axis.text.x = element_blank(), axis.text.y = element_blank()) +
                                 ggtitle("Relationship between knowledge of Open science and Concern with researcher dfs")
                                 ggplotly(p1)
                                 })
  
  output$BadRepl <- renderPlotly({p2 <- ggplot(df, aes(DFbad, Replicable)) + 
                                 geom_point(aes(colour = Faculty, shape = DataPerson)) + geom_smooth(method="lm", se = FALSE) +  
                                 coord_cartesian(xlim = c(1, 7), ylim = c(1, 100)) + 
                                 theme_classic() +
                                 theme(axis.text.x = element_blank(), axis.text.y = element_blank()) +
                                 ggtitle("Relationship between Concern with researcher dfs and estimated replicability of field")
                                 ggplotly(p2)
                                 })  
     
})
