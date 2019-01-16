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

DATAHOME=${HOME}/Data/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

if [ ! -z $CSV_FILE ]
then
  CSVLOADFILE="${CSV_FILE}"
else
  CSVLOADFILE="${LOADHOME}/price-diff/price-diff-s_price.csv"
fi

echo "CSVLOADFILE=${CSVLOADFILE}"

CURR_DATE=`date "+%Y-%m-%d"`

echo ${CURR_DATE}
echo ${LOADHOME}/price_new-${CURR_DATE}.csv

psql << EOF

  DELETE FROM s_price;

  \COPY s_price FROM ${CSVLOADFILE} DELIMITER ',' CSV HEADER

  INSERT INTO price_new(
      p_date,
      p_fund,
      p_price)
    SELECT
      sp_date,
      sp_fund,
      sp_price
    FROM
      s_price
    EXCEPT
    SELECT
      p_date,
      p_fund,
      p_price
    FROM
      price_new
    ;

  -- Delete rows where p_price IS NULL. This will remove any blank rows which get imported.

  DELETE FROM price_new WHERE p_price IS NULL;


  -- Take a backup of the current price_new data.

  \COPY price_new TO '${LOADHOME}/price_new-${CURR_DATE}.csv' DELIMITER ',' CSV HEADER;

  -- Generate SMA Data. This adds SMA data into the analytic_rep table.

  SELECT FROM sma();

EOF
exit 0
# remove data files older than 10 days.

# Deleting files older than 10 days.
echo "Removing files older than 10 days."
find ${UNLOADHOME} -name 'FULL-*-PRICE.csv' -mtime +10 -exec rm {} \;

