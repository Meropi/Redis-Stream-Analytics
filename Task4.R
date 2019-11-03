#TASK 4

#This requires parallel execution of TASK 3

while (TRUE){
  while (length(r$KEYS("PRICE *"))==0){
    print ("Start the stream, please!")
  }
  for (i in r$KEYS("PRICE *")){
    print(i)
    #Get the current max min average values carrently saved in the has. 
    print(paste("MAX:", round(as.numeric(unlist(r$HGET(i, "max"))),3)))
    print(paste("MIN:", round(as.numeric(unlist(r$HGET(i, "min"))),3)))
    print(paste("AVERAGE:", round(as.numeric(unlist(r$HGET(i, "avg"))),3)))
    print("---------------")
    
  }
}
