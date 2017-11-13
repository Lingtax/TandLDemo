library(shiny)
library(googlesheets)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Demonstration of Live Data interactions"),
  
  
  fluidRow(
    column(3, plotOutput("knowFac")),
    column(3, plotOutput("replFac")),
    column(3, plotOutput("DPDFrate"))
           ),
  
      hr(),
  fluidRow(
    column(6, plotOutput("knowbad")),
    column(6, plotOutput("BadRepl"))
    )
  )
)
