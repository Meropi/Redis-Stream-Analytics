#TASK 5

#This requires parallel execution of TASK 3


while (TRUE){
  while (length(r$KEYS("PRICE30 *"))==0){
    print ("Start the stream, please!")
  }
  # This will be performed for each stock.
  for (i in r$KEYS("PRICE30 *")){
    print(i)
    #For testing purposes: print(r$LLEN(i))
    #Fetches the 30 values currently saved in the list and calculates the average.
    print(paste("AVERAGE:", round(mean(as.numeric(unlist(r$LRANGE(i, 0, -1)))),3)))
    print("---------------")
    
  }
}
