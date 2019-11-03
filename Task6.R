#TASK 6

#This requires execution of TASK 1 and parallel execution of TASK 3

while (TRUE){
  while (length(r$KEYS("PRICE *"))==0){
    print ("Start the stream, please!")
  }
  #This will be performed for each stockid
  for (i in r$KEYS("PRICE *")){
    print(i)
    #Fetch the average of the current stock from the hash
    #For testing purposes:print(paste("AVERAGE:", as.numeric(unlist(r$HGET(i, "avg")))))
    current_avg<-as.numeric(unlist(r$HGET(i, "avg")))
    #Take the ID of the current stock
    stock<-unlist(strsplit(unlist(i), " "))[2]
    #For testing purposes: print(paste("stock", stock ))
    #For the specific stock take the price close from the hash we saved the .csv file
    price_close<-as.numeric(r$HMGET(paste("stockid:",stock), "price_close"))
    #Calculate the percentage difference
    perce_diff<-((current_avg-price_close)/price_close)*100
    #For testing purposes: print(paste("PRICE CLOSE", price_close))
    print(paste("PERCENTAGE DIFFERENCE",round(perce_diff,3),"%"))
    print("---------------")
    #We used testit function in order to slow down the execution time of the while loop by 1 sec
    #with the aim off aligning the times that the Task 3 stream saves the data in Redis and the time
    #it takes to read them in Task 6.
    testit(1)
    
    
  }
}

#Function that when is called slows down the execution of the program
testit <- function(x)
{
  p1 <- proc.time()
  Sys.sleep(x)
  proc.time() - p1
}