#TASK 7
#This requires execution of TASK 1 and TASK 2 and parallel execution of TASK 3

while (TRUE){
  if (length(r$KEYS("BUY/SELL30 *"))==0){
    print ("Start the stream, please!")
  }
  #This will be performed for each stockid
  for (i in r$KEYS("BUY/SELL30 *")){
    if (r$LLEN(i)<30){
      print(paste("Please wait the list to be populated with 30!"))}
    else{
      
      #For testing purposes: print(paste("stockID:",i))
      #For testing purposes: print(r$LLEN(i))
      #calculates the mean value of the last 30 buy/sell ratios
      avg_buy_sell_30<-mean(as.numeric(unlist(r$LRANGE(i, 0, -1))))
      
      #For testing purposes: print(paste("AVERAGE:", avg_buy_sell_30))
      #Takes tha value of current stock_od (example: GOOG)
      stock_id<-unlist(strsplit(unlist(i), " "))[2]
      
      #Fetches from the multi value set the previous day's volume_buy/volume_sell and calculates their division
      last_day_ratio<-as.numeric(r$HMGET(paste("stockid:",stock_id), "volume_buy"))/as.numeric(r$HMGET(paste("stockid:",stock_id), "volume_sell"))
      #For testing purposes: print(paste("last_day_ratio:",last_day_ratio))
      
      #Fetches from the hash and saves the last day's avg_sentiment
      sentiment<-as.numeric(r$HMGET(paste("stockid:",stock_id), "avg_sentiment"))
      #print(paste("sentiment:", sentiment))
      
      if (avg_buy_sell_30>last_day_ratio & sentiment>2.5 ){
        print(paste ("StockID with avg of last 30 buy/sell ratios > than the yesterday's and sentiment>2,5:",stock_id))
        print("---------------")
      }
      
    }
  }
}
