library(shiny)
library(googlesheets)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Demonstration of Live Data interactions"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      h1("Group differences"),
      selectInput("diffCat", "Difference between: ",
                   choices = c("Faculty",
                               "DataPerson"),
                   selected = "Faculty"),
      selectInput("diffCon", "Difference on: ",
                   choices = c("OpenSciKnowledge",
                               "ReplicabilityField",
                               "ResDFRate"), 
                   selected = "OpenSciKnowledge"),
      hr(),
      h1("Relationships"),
      selectInput("rel1", "Difference on: ",
                choices = c("Languages",
                            "Siblings",
                            "Age",
                            "heightmetres",
                            "Anxious")),
      selectInput("rel2", "Difference on: ",
                  choices = c("Languages",
                            "Siblings",
                            "Age",
                            "heightmetres",
                            "Anxious"),
                 selected = "Siblings")
      ),
      
    
    mainPanel(
      fluidRow(tableOutput("diffTable"),
              plotOutput("diffPlot")),
      hr(),
      fluidRow(textOutput("rel"),
              plotOutput("relPlot"))
                       
    )
  )
))
