#TASK3

#Create Remote Connection with REDIS
r <- redux::hiredis(
  redux::redis_config(
    host = "redis-10184.c14.us-east-1-3.ec2.cloud.redislabs.com", 
    port = "10184", 
    password = "mscba2018"))

#Create socket connection
con <- socketConnection(host="46.101.203.215", port = 1337, blocking=TRUE,
                        server=FALSE, open="r+")


#This counters are used for purposes of TASK 4.
index<-1
vector<-c(1:11)

#We use variable goog for TASK 8, to ensure that if the last 20 seconds the same value appears, this value will be saved too. 
#This is because sorted sets contain only unique values. So if a same value is going to be saved without the use of goog,
#Redis will ignore it and the average of the last 20 seconds won't be valid.
goog<-1
while(TRUE){
  
  #Read each line of the stream
  server_resp <- readLines(con, 1)
  
  #Print each line of the stream
  print(server_resp)
  
  #####################################################################################################
  
  ################################# FOR TASK 4/ TASK 6 (only average) #################################
  
  #Create one Mutli-set value hash per stockID (11 hashes in total) and
  #initialize the values (for avg 0, for min sth big, for max sth small,  and for count 1 )
  #Note: count will be used later to calculate the new average.
  #This will be executed only the first time each stockid appears, as we noticed that they run on a certain pattern
  #eleven by eleven.
  
  if (index %in% vector){
    r$HMSET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), c("avg", "min", "max", "count"), c("0","1000000000","-1000000000", "1"))
    index=index+1
  }
  
  # Assign current price in a variable
  current_price<-as.numeric(unlist(strsplit(server_resp,","))[2])
  
  #Fetch the current saved max
  max<-as.numeric(r$HGET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), "max"))
  
  #Fetch the current saved min
  min<-as.numeric(r$HGET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), "min"))
  
  #Fetch the current average
  avg<-as.numeric(r$HGET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), "avg"))
  
  #Fetch the current n for calculate later the average
  n<-as.numeric(r$HGET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), "count"))
  
  #Calculate and save max. We compare each time the current price of the stream with the already saved max and if
  #the current price is bigger than the saved max we keep this as max.
  if (current_price>max){
    
    r$HMSET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), c("max"), (current_price))
    
  }
  
  #Calculate and save min. We compare each time the current price of the stream with the already saved min.
  if (current_price<min){
    
    r$HMSET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), c("min"), (current_price))
    #Used for testing: print (paste("LOOOKKKKKKKKKKKKKKKKKKKKKKKKKK", r$HGET("PRICE CSCO", "min")))
    
  }
  
  #Calculate avg-This is the mathematical formula for calculating the average when 
  #an additional item is added (no need to have the previous prices!!!!)
  
  new_average<-avg+((current_price-avg)/n)
  
  #Save average to the current Hash and Increase n by 1 (we need to keep how many items passed so far
  #for the mathematical calculation)
  r$HMSET(paste("PRICE",unlist(strsplit(server_resp,","))[1]), c("avg"), (new_average))
  r$HINCRBY(paste("PRICE",unlist(strsplit(server_resp,","))[1]), c("count"), 1)
  
  ##########################################################################################
  
  ################################# FOR TASK 5/ FOR TASK 7 #################################
  
  #Until the list to be populated with 30 elements we just push elements to it
  if(r$LLEN(paste("PRICE30",unlist(strsplit(server_resp,","))[1]))<30){
    
    # Lists that keep the last 30 stock prices (one list for each stockID)
    r$RPUSH(paste("PRICE30",unlist(strsplit(server_resp,","))[1]), unlist(strsplit(server_resp,","))[2])
    
    # Lists that keep the last 30 buy/sell ratios (one list for each stockID)
    r$RPUSH(paste("BUY/SELL30",unlist(strsplit(server_resp,","))[1]), as.numeric(unlist(strsplit(server_resp,","))[4]) / as.numeric(unlist(strsplit(server_resp,","))[3] ))
  }
  #After the list has filled in with 30 elements we remove the first (left pop) and we add at the end
  #the current one (right push) so that the list has always 30 elements. To ensure that the list won't
  #be in a state that has 29 elements we include our code in  MULTI()-EXEC()
  else{
    r$MULTI()
    
    r$LPOP(paste("PRICE30",unlist(strsplit(server_resp,","))[1]))
    r$RPUSH(paste("PRICE30",unlist(strsplit(server_resp,","))[1]), unlist(strsplit(server_resp,","))[2])
    
    r$LPOP(paste("BUY/SELL30",unlist(strsplit(server_resp,","))[1]))
    r$RPUSH(paste("BUY/SELL30",unlist(strsplit(server_resp,","))[1]), as.numeric(unlist(strsplit(server_resp,","))[4]) / as.numeric(unlist(strsplit(server_resp,","))[3] ))
    
    r$EXEC()
  }
  
  ##########################################################################################
  
  ################################# FOR TASK 8 #############################################
  
  #Create a sorted set of prices of the Googe's stock that have as score the timestamp
  #Regarding the value we use a concatenation of the current price and the variable goog.

  if(unlist(strsplit(server_resp,","))[1]=="GOOG"){
    
    #We take the first element of Time() which is the Current Unix Timestamp that the current_price saved in Redis
    r$ZADD("GOOGLE_PRICE",  unlist(r$TIME())[1], paste(current_price, goog))
    
    #We save the length of the list in R (sorted set comes as list) in order to get the last item
    #which is the current timestamp because we need it in order to keep only the prices of the last
    #20 seconds.
    current_timestamp_index<-length(unlist(r$ZRANGE("GOOGLE_PRICE", 0,-1, "WITHSCORES")))
    current_timestamp
    #For testing purposes: print(paste("GOOOOOOOOOOOOOGLLLLLLLLEEEEEEEEEEE",r$ZRANGE("GOOGLE_PRICE", 0,-1, "WITHSCORES")))
    current_timestamp<-as.numeric(r$ZRANGE("GOOGLE_PRICE", 0,-1, "WITHSCORES")[current_timestamp_index])
    
    #removes whatever has been kept to the set to the current_timestamp minus 20 seconds, so 
    #the last twenty seconds to be always in the set
    r$ZREMRANGEBYSCORE("GOOGLE_PRICE", "-inf", current_timestamp-20)
    goog<-goog+1
  }
  
  
}

#Close connection
close(con)

