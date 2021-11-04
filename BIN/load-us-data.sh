#!/bin/bash

# load-us-data.sh
# Sam Matthews
# Created: 20th September

# Load data from US Stock Market.
# Use the following API to achieve this.
# https://www.alphavantage.co/query\?function=TIME_SERIES_DAILY\&symbol=AAPL\&apikey=WHWGAETT94IZAL0B\&datatype=csv\&datatype=csv

# SETUP API
API_BASE="https://www.alphavantage.co/query\?function=TIME_SERIES_DAILY"
SYMBOL="AAPL"
APIKEY="WHWGAETT94IZAL0B"
DATATYPE="csv"

# Sample command
URL="${API_BASE}\&symbol=${SYMBOL}\&apikey=${APIKEY}\&datatype=${DATATYPE}"
echo curl ${URL} --output AAPL.csv
