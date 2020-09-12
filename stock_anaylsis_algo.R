#initialize
setwd('D:/analysis')
library(tidyverse)
inslibrary(rvest)
library(magrittr)
library(ggplot2)
library(tidyquant)
library(alphavantager)
av_api_key('AV API KEY')
NYSE <- read_csv('NYSE_TICKERS.csv')

tickers <- NYSE$`ACT Symbol`

#Helper functions
per_change <- function(stock){
  stock$per_change <- (stock$close-stock$open)/stock$open
  return(stock)
}

get_stock <- function(sym){
  tryCatch({
  stock<- av_get(symbol = sym, av_fun = "TIME_SERIES_INTRADAY", interval = "15min", outputsize = "full")
  
  }, finally = {
    stock <- 'PASS'
  })
  
  
  return(stock)
}
per_diff <- function(a, b){
  return(abs(b-a)/a)
}


#Algo
delphi <- function(stock1, stock2){
  margin = 0.01
  stock1 %<>% per_change()
  stock2 %<>% per_change()
  similarity = 0
  total = 0
  for (a in 1:length(stock1$per_change)){
    if(a<5){
      for (b in a:a+4 ){
        d <- per_diff(stock1$per_change[a], stock2$per_change[b])
        if (d <= margin){
          similarity = similarity + 1
        }}
       }else{
          if(a > 5 && a < length(stock1)-5){
            for (b in a-4:a+8 ){
              d <-per_diff(stock1$per_change[a], stock2$per_change[b])
              if (d <= margin){
              similarity = similarity + 1
              }}
            }else{
              
                if (a > 9 && a < length(stock1) - 9){
                   for (b in a-8:a+8 ){
                      d <- per_diff(stock1$per_change[a], stock2$per_change[b])
                      if (d <= margin){
                      similarity = similarity + 1
                      }}    
                }else{
                            

                    if(a > length(stock1) - 5){
                      for (b in a-8:a ){
                          d <- per_diff(stock1$per_change[a], stock2$per_change[b])
                          if (d <= margin){
                            similarity = similarity + 1
                          }}
                    
          total = total +1
                      }}}}}
  return(similarity/total)
}


stocks_compare <- data.frame(tickers)





for (x in length(tickers)){
  tryCatch({stock = get_stock(tickers[x])}, finally = {stock = 'PASS'})
  if (stock != 'PASS'){
    
  
  compare <- c(NaN)
  length(compare) <- length(tickers)
  for (y in length(tickers)){
    if(y != x){
      temp <- get_price(tickers[y])
      compare[y] <- delphi(stock, temp)
      print(compare[y])
    } else {
      compare[y] <- 1
    }
  } 

  stocks_compare[tickers[x]] <- compare
  }
}

stocks_compare


write.csv(stocks_compare, 'Stock_relationship_data.csv')


