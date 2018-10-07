#!/bin/bash

APPNAME="funds"
APPHOME="${HOME}/Documents/CODE/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"

DATAHOME=${HOME}/DOCUMENZTASDATA/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

CSVLOADFILE="${LOADHOME}/price-diff/price-diff-s_price.csv"

CURR_DATE=`date "+%Y-%m-%d"`

psql << EOF

  DELETE FROM s_price;

  COPY s_price(
    sp_date,
    sp_fund,
    sp_price)
    FROM '$CSVLOADFILE' DELIMITER ',' CSV HEADER;

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

  COPY (
    SELECT
      p_date,
      p_fund,
      p_price
    FROM price_new ORDER BY p_date)
    TO '$UNLOADHOME/FULL-${CURR_DATE}-PRICE.csv' DELIMITER ',' CSV HEADER;

EOF

# remove data files older than 10 days.

# Deleting files older than 10 days.
echo "Removing files older than 10 days."
find ${UNLOADHOME} -name 'FULL-*-PRICE.csv' -mtime +10 -exec rm {} \;

