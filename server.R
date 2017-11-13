library(shiny)
library(gsheet)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    df <-  gsheet2tbl('docs.google.com/spreadsheets/d/1tk5bX8e0OfcYcB6qndiVZ2X46m9O0Cy1H2pDRrlRoNY') %>% 
      mutate(Timestamp = lubridate::mdy_hms(Timestamp),
              Faculty	     = as.factor(Faculty),
              Teach_UG     = grepl("Undergraduates", GroupsTaught),
              Teach_PG     = grepl("Postgraduates (Coursework)", GroupsTaught),
              Teach_Res    = grepl("Research Students", GroupsTaught), 
              DataPerson	 = as.factor(DataPerson),
              ReplicabilityField = ReplicabilityField*10
            )
##### work from here, rates by faculty, difference between data people and non-data people relationship between knowledge and Replicability

  # differences
  output$diffFac <- renderTable({as.data.frame(group_by_(df, input$diffCat) %>% 
                                                   summarize(mean(!!rlang::sym(input$diffCon))))})
  
  output$diffPlot <- renderPlot(ggplot(df, aes_string(input$diffCat, input$diffCon, colour = input$diffCat, group = input$diffCat)) + 
                                  geom_violin() + geom_jitter(alpha=.5) + theme_classic()
                                )
  # relationships
  subs <- reactive({select(df, input$rel1, input$rel2)})
  output$rel <- renderText({
    corr <-  cor(subs())
    paste("The relationship has a correlation coefficient of", round(corr[1, 2], 2))
    })
  output$relPlot <- renderPlot(ggplot(subs(), aes_string(input$rel1, input$rel2)) + 
                                 geom_point() + geom_smooth(method="lm", se = FALSE) +  
                                 theme_classic()
                               )
    
     
  output$table <- renderTable(head(df))
  
})
