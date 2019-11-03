#TASK 8

#This requires parallel execution of TASK 3

while (TRUE){
  
  while(length(r$ZRANGE("GOOGLE_PRICE", 0,-1))==0){
    print ("Start the stream, please!")
  }
  #We keep the values of the sorted set with key GOOGLE_PRICE.
  list<-strsplit(unlist(r$ZRANGE("GOOGLE_PRICE", 0,-1))," ")
  #Number of items of the list
  items<-length(list)
  sum<-0
  # Calculates the sum of the items saved the last 20 seconds in Redis
  for (g in 1:items){
    sum<-sum+as.numeric(list[[g]][1])
  }
  #Calculate the average
  mean_goog<-sum/items
  print(paste("Average GOOG Price saved the last 20s:", mean_goog))
  
}