#!/bin/bash

# Sam Matthews

# Potential changes.
# Add Funds to a lookup table, then scan through this table instead of looking through an external file.
# Added release tag 0.1

CSV_FILE=$1
APPNAME="funds"
APPHOME="${HOME}/Code/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"
SQLHOME="${DBHOME}/sql"

DATAHOME=${HOME}/Data/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

# Commands

if [ ! -z $CSV_FILE ]
then
  CSVLOADFILE="${CSV_FILE}"
else
  CSVLOADFILE="${LOADHOME}/price-diff/price-diff-s_price.csv"
fi

# echo "CSVLOADFILE=${CSVLOADFILE}"

CURR_DATE=`date "+%Y-%m-%d"`

# echo ${CURR_DATE}
# echo ${LOADHOME}/price_new-${CURR_DATE}.csv

echo "Load new data"

echo "Truncating s_price"
psql -q -t -c "TRUNCATE TABLE s_price;"

echo "copy new data"
psql -q -t -c "\COPY s_price FROM ${CSVLOADFILE} DELIMITER ',' CSV HEADER"

echo "load-staging"
psql -q -f "${SQLHOME}/load-staging.sql"

echo "Unload Motive Wave Data"
${HOME}/Code/funds/postgres/load/unload-mw-new.sh

echo "Delete any NULL Data."
psql -q -t -c "DELETE FROM price_new WHERE p_price IS NULL"

echo "Export current data"
psql -q -t -c "\COPY price_new TO '${LOADHOME}/price_new-${CURR_DATE}.csv' DELIMITER ',' CSV HEADER;"

cp -p ${LOADHOME}/price_new-${CURR_DATE}.csv ${UNLOADHOME}/latest-price-data.csv

echo "Populate analytical studies"
psql -q -t -c "TRUNCATE TABLE analytic_rep;"

echo "Generate price"
psql -q -t -c "SELECT FROM load_price_to_rep();"

echo "Generate SMA"
psql -q -t -c "SELECT FROM sma();"

echo "Generate STDDEV and Volatility"
psql -q -t -c "SELECT FROM stddev();"

echo "Generate Bollinger"
psql -q -t -c "SELECT FROM bollinger();"

echo "Generate RSI"
psql -q -t -c "SELECT FROM rsi();"

echo "Generate EMA"
psql -q -t -c "SELECT FROM ema();"

echo "Generate MACD"
psql -q -t -c "SELECT FROM macd();"

echo "Generate summary data"
${HOME}/Code/funds/postgres/load/load-summary-data.sh

echo "Generate score data."
psql -q -t -c "select from study_score();"

echo "Removing files older than 10 days."
find ${LOADHOME} -name 'FULL-*-PRICE.csv' -mtime +10 -exec rm {} \;
