#!/bin/bash

# Assumptions:
# File been loaded is always FULL-PRICE-DB-LOAD.csv
# Update script for updated directory locations.

APPNAME="funds"
APPHOME="${HOME}/Code/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"

DATAHOME=${HOME}/Data/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

CSVFILE="FULL-PRICE-DB-LOAD.csv"

CSVLOADFILE="${LOADHOME}/${CSVFILE}"
echo "${CSVLOADFILE}"

psql << EOF

  TRUNCATE s_price;
  TRUNCATE price_new;

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
EOF
