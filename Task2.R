#TASK 2

library("rjson")

#read the json file and save it as a list. 
json_data<- fromJSON(paste(readLines("sentiment.json"), collapse=""))
#If the Warning: In readLines("sentiment.json") incomplete final line found on 'sentiment.json'
#appears then open the file with notepad navigate to the last line of the file, place the cursor
#at the end of that line, press Enter and Save it.


#For each stockid, do the following:
for (i in 1:11){
  
  #save the stockid value in the key
  key<-paste("stockid:",names(json_data[i]))
  
  #Find the number of sentiment values of the stock(For example CSCO has 4 sentiment values)
  jnum<-length(unlist(json_data[i]))/2
  
  #Calculate the sum of sentiment values of the stock.
  value_sentiment<-0
  for (j in 1:jnum){
    value_sentiment<-value_sentiment+json_data[[i]][[j]]$sentiment
  }
  
  #Calculate the average sentiment value of the stock -division of the sum we found above and the number
  #of sentiment values of the stock
  result<-value_sentiment/jnum
  
  #Add the result as an extra pair of field-value ("avg_sentiment"-result)
  #in the already created from task 1 Mutli-set value hash.
  
  r$HSET(key, "avg_sentiment", result)
  ##Used for testing: print (paste("result", key, result ))
}