library(shiny)

if(!require("dygraphs")){
  install.packages("dygraphs")
  library(dygraphs)
}

if(!require("shinyBS")){  
  install.packages("shinyBS")
  library(shinyBS)
}

shinyUI(fluidPage(
  titlePanel("Mini Finance Data Lookup"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Enter a Symbol and Select Data Source for Corresponding Symbol "),
    
      textInput("symb", "Symbol", "SPY"),
      
      bsTooltip(id="symb",title="Enter Symbol like APPL...",placement = "right",trigger="hover"),
      
      selectInput("symbSource",label=h4("Data source"),
                  choices=list("Yahoo Finance (OHLC data)" = "yahoo",
                               "FRED (economic series)" = "FRED",
                               "Oanda (FX and Metals)"= "oanda"
                  ),selected="yahoo"),
      bsTooltip(id="symbSource",title="Yahoo(AAPL etc),FRED(CPIAUCNS etc),Oanda(USD/EUR) ",placement = "right",trigger="hover"),
      
      helpText("Select date range of time series "),
      dateRangeInput("dates", 
        "Date range",
        start = "2013-01-01", 
        end = as.character(Sys.Date())),
      helpText("Click on the tab to view the price time series and return analysis ")
      

    ),
    
    mainPanel(
      bsCollapse(id = "collapseExample", open = "Time Series of Price",
      bsCollapsePanel("Time Series of Price ", "Closed-price of the symbol from corresponding data source",
                      dygraphOutput("plotTS")),
      bsCollapsePanel("Time Series of Return", "Calculated price return of the symbol",
                      dygraphOutput("plotReturn")),
      bsCollapsePanel("Return Exploratory Analysis", "Explorratory analysis of return",
                      plotOutput("distPlot"))
                     
      )
    )

)))