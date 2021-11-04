#!/bin/bash

# Assumptions:
# File been loaded is always FULL-PRICE-DB-LOAD.csv
# Update script for updated directory locations.

APPNAME="funds"
DBHOME="${APP_HOME}/postgres"
CFGHOME="${DBHOME}/cfg"

UNLOAD_HOME="${DATA_HOME}/unload"
LOAD_HOME="${DATA_HOME}/load"

CSV_FILE="FULL-PRICE-DB-LOAD.csv"

CSVLOAD_FILE="${LOAD_HOME}/${CSV_FILE}"
echo "${CSVLOAD_FILE}"

psql << EOF

  TRUNCATE s_price;
  TRUNCATE price_new;

  \COPY s_price FROM ${CSVLOAD_FILE} DELIMITER ',' CSV HEADER

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
