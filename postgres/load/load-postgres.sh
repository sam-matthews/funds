#!/bin/bash

# Sam Matthews

# Potential changes.
# Add Funds to a lookup table, then scan through this table instead of looking through an external file.
# Added release tag 0.1

DEBUG=ON

CSV_FILE=$1
DBHOME="${FUNDS_APP}/postgres"
CFGHOME="${DBHOME}/cfg"
SQLHOME="${DBHOME}/sql"
DBLOADHOME="${DBHOME}/load"

UNLOADHOME="${FUNDS_DAT}/unload"
LOADHOME="${FUNDS_DAT}/load"


if [[ ${DEBUG} -eq "ON" ]]; then
  echo "LOADHOME=$LOADHOME"
  echo "UNLOADHOME=$UNLOADHOME"
  echo "CFG_HOME=$CFGHOME"
fi

# Commands

echo "Step 1. Define parameters"
if [ ! -z $CSV_FILE ]
then
  CSVLOADFILE="${CSV_FILE}"
else
  CSVLOADFILE="${LOADHOME}/price-diff/price-diff-s_price.csv"
  CSVDATEFILE="${LOADHOME}/price-diff/price-diff-Start.csv"
  CURR_DATE=`awk -F',' '{ if ($1 == "New Data") { print $2 } }' ${CSVDATEFILE} | sed 's/\///g'`
fi

# Backup file

cp -p ${CSVLOADFILE} ${UNLOADHOME}/price-diff-s_price-${CURR_DATE}.csv

echo "Load new data"

echo "Truncating s_price"
psql -q -t -c "TRUNCATE TABLE s_price;"

echo "copy new data"
psql -q -t -c "\COPY s_price FROM ${CSVLOADFILE} DELIMITER ',' CSV HEADER"

echo "Load staging data"
psql -q -f "${SQLHOME}/load-staging.sql"

echo "Unload Motive Wave Data"
${DBLOADHOME}/unload-mw-new.sh

exit 10

echo "Delete any NULL Data."
psql -q -t -c "DELETE FROM price_new WHERE p_price IS NULL"

echo "UNLOAD price_new data"
psql -q -t -c "\COPY price_new TO '${UNLOADHOME}/price_new-${CURR_DATE}.csv' DELIMITER ',' CSV HEADER;"

echo "COPY current data to standard CSV file - easy to backup"
cp -p ${UNLOADHOME}/price_new-${CURR_DATE}.csv ${UNLOADHOME}/latest-price-data.csv

#echo "Run any changes to load_sma_fund_data changes"
#psql -f ${DBHOME}/load/load-sma-fund-data.fun

#echo "RELOAD DATA INTO analytic_lkp BASED ON r_fund TABLE."
#psql -q -t -c "SELECT FROM load_sma_fund_data();" -c "\q"

#echo "TRUNCATE analytic_rep TABLE"
#psql -q -t -c "TRUNCATE TABLE analytic_rep;"

#echo "LOAD price DATA FROM price_new TO analytic_rep"
#psql -q -t -c "SELECT FROM load_price_to_rep();" -c "\q"

#echo "LOAD SMA DATA INTO analytic_rep"
#psql -q -t -c "SELECT FROM sma();" -c "\q"

# echo "Generate STDDEV and Volatility"
# psql -q -t -c "SELECT FROM stddev();"

# echo "Generate Bollinger"
# psql -q -t -c "SELECT FROM bollinger();"

# echo "Generate RSI"
# psql -q -t -c "SELECT FROM rsi();"

# echo "Generate EMA"
# psql -q -t -c "SELECT FROM ema();"

# echo "Generate MACD"
# psql -q -t -c "SELECT FROM macd();"

#echo "Generate summary data"
#${DB_HOME}/load/load-summary-data.sh

# echo "Generate score data."
# psql -q -t -c "select from study_score();"

echo "Removing files older than 10 days."
find ${LOADHOME} -name 'FULL-*-PRICE.csv' -mtime +10 -exec rm {} \;
