library(shiny)
library(googlesheets)
library(plotly)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Demonstration of Live Data interactions"),
  
  
  fluidRow(
    column(4, plotOutput("knowFac")),
    column(4, plotOutput("replFac")),
    column(4, plotOutput("DPDFrate"))
           ),
  
      hr(),
  fluidRow(
    column(6, plotlyOutput("knowbad")),
    column(6, plotlyOutput("BadRepl"))
    )
  )
)
