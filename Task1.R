#Clean R memory
r$FLUSHALL()


#Create connection
r <- redux::hiredis(
  redux::redis_config(
    host = "redis-10184.c14.us-east-1-3.ec2.cloud.redislabs.com", 
    port = "", 
    password = ""))

#TASK 1

#Read the aggregated_stock_data.csv
AggData<-read.table ("aggregated_stock_data.csv", header=TRUE, sep=",")

#Create a Hash of multi-set values for each stockID
for (i in 1:11){
  r$HMSET(paste("stockid:",AggData[i,1]), c("price_open", "price_close", "volume_buy", "volume_sell"), 
          c(AggData[i,2], AggData[i,3], AggData[i,4], AggData[i,5]))
  
}