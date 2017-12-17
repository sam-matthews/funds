#!/bin/bash

APPHOME="${HOME}/source/Security"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"
UNLOADHOME="${APPHOME}/data/unload"
LOADHOME="${APPHOME}/data/load/price-diff"

CSVLOADFILE="${LOADHOME}/price-diff-s_price.csv"

CURR_DATE=`date "+%Y-%m-%d"`

psql << EOF

  DELETE FROM s_price;

  COPY s_price(
    s_price_date,
    s_price_secu,
    s_price_type1,
    s_price_type2,
    s_price_price)
    FROM '$CSVLOADFILE' DELIMITER ',' CSV HEADER;

    INSERT INTO price(
      price_date,
      price_secu,
      price_type1,
      price_type2,
      price_price)
    SELECT
      s_price_date,
      s_price_secu,
      s_price_type1,
      s_price_type2,
      s_price_price
    FROM
      s_price
    EXCEPT
    SELECT
      price_date,
      price_secu,
      price_type1,
      price_type2,
      price_price
    FROM
      price
    ;

  COPY (
    SELECT
      price_date,
      price_secu,
      price_type1,
      price_type2,
      price_price
    FROM price ORDER BY price_date)
    TO '$UNLOADHOME/FULL-${CURR_DATE}-PRICE.csv' DELIMITER ',' CSV HEADER;

EOF

# remove data files older than 10 days.

# Deleting files older than 10 days.
echo "Removing files older than 10 days."
find ${UNLOADHOME} -name 'FULL-*-PRICE.csv' -mtime +10 -exec ls -l {} \;

