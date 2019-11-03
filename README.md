# Redis-Stream-Analytics

The scenario on artificial data here is that we have access to a data stream of stock prices and buy/sell volumes of several popular companies’ stocks. We also have access to previous day’s aggregated information about these stocks.

The purpose is to use Redis (in-memory data structure project implementing an in-memory key-value database) and Redux, a Redis client for R and to perform some transformations.

The programs are handling the following tasks:

* Task 1 

Reads the data stored in “aggregated_stock_data.csv” and store values per stock id to Redis in an appropriate format. 

* Task 2

Read the data stored in “sentiment.json” and stores values per stock id to Redis in an appropriate format.  

* Task 3

Read the stream and stores values per stock id to Redis in an appropriate format.  

* Task 4

Read in from Redis and prints out for each stock id the average, minimum and maximum price since the starting point of storing the data stream. Write your program in a way that minimizes memory usage.

* Task 5

Reads in from Redis and prints out for each stock id the average price of the last 30 stock’s reported prices (a sliding window of size 30).

* Task 6

Reads in from Redis and prints out for each stock id the difference (as a percentage) of the average price of each stock since the starting point of storing the data stream, compared to the closing price of this stock (available at the .csv file). 

* Task 7

Reads in from Redis and prints out the stock ids that:
	- Have an average buy/sell ratio of the last 30 reported prices that is bigger than last day’s buy/sell ratio (available at the .csv file).
	- And at the same time an average sentiment value that is bigger than 2.5 (available at the .json file).

* Task 8

Reads in from Redis and prints out the average price of the GOOG’s stock for the last 20 seconds (a sliding window of 20 seconds).
