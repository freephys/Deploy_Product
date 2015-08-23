# server.R

if(!require("quantmod")){
  install.packages("quantmod")
  library(quantmod)
}

if(!require("PerformanceAnalytics")){
  install.packages("PerformanceAnalytics")
  library(PerformanceAnalytics)
}

if(!require("dygraphs")){
  install.packages("dygraphs")
  library(dygraphs)
}


shinyServer(function(input, output) {

  output$plotTS <- renderDygraph({
    data <- getSymbols(input$symb,from = input$dates[1],to = input$dates[2],src = input$symbSource,auto.assign = FALSE)
    if(as.character(input$symbSource) == "FRED"){
      dygraph(data,main = "Economic Data from Fed",group="fredData") %>% dyRangeSelector()
    }else if(as.character(input$symbSource) == "oanda"){
      dygraph(data,main = "FX Data from Oanda",group="oanda") %>% dyRangeSelector()
    }else if(as.character(input$symbSource) == "yahoo"){
      dygraph(Cl(data),main = "Stock Price From Yahoo",group="yahooData") %>% dyRangeSelector()
    }
  })  
  
  output$plotReturn <- renderDygraph({
    data <- getSymbols(input$symb,from = input$dates[1],to = input$dates[2],src = input$symbSource,auto.assign = FALSE)
    if(as.character(input$symbSource) == "FRED"){
      dygraph(as.xts(Return.calculate(data),method = "log"),main = "Return",group="fredData") %>% dyRangeSelector()
    }else if(as.character(input$symbSource) == "oanda"){
      dygraph(as.xts(Return.calculate(data),method = "log"),main = "FX Data from Oanda",group="onada") %>% dyRangeSelector()
    }else if(as.character(input$symbSource) == "yahoo"){
      dygraph(as.xts(Return.calculate(Cl(data)),method = "log"),main = "Return",group="yahooData") %>% dyRangeSelector()
    }
  })
  
  output$distPlot <-  renderPlot({
    tmp <-getSymbols(input$symb,from = input$dates[1],to = input$dates[2],src = input$symbSource,auto.assign = FALSE)
    if(as.character(input$symbSource) == "yahoo"){
      Adtmp <- Return.calculate(Ad(tmp),method = c("log"))      
    }else{
      Adtmp <- Return.calculate(tmp,method = c("log"))   
    }

    par(mfrow = c(2,3))
    hist(Adtmp, main="Histogram of Return", xlab="Return")
    boxplot(as.data.frame(Adtmp),ylab="Return",main="Boxplot of Return ",horizontal = T)
    qqnorm(as.vector(na.omit(Adtmp[,1])),main="Normal Q-Q Plot of Return")
    qqline(as.vector(na.omit(Adtmp[,1])))
    plot(density(as.vector(na.omit(Adtmp[,1])), type = "l", xlab = "Return", 
         ylab = "density estimate", col = "slateblue1"),main="Kernel Density Plot of Return")
    acf(as.vector(na.omit(Adtmp[,1])),main="ACF of Return")
    pacf(as.vector(na.omit(Adtmp[,1])),main="PACF of Return")

    
  })
})
