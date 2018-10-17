#!/bin/bash

# 
#  load-all-data.sql
#   Sam Matthews
#  17th October 2018
#
#  Load the latest DATA FIle.
# */


APPNAME="funds"

DATAHOME=${HOME}/Documents/DATA/${APPNAME}
LOADHOME="${DATAHOME}/load"
UNLOADHOME="${DATAHOME}/unload"

CURR_DATE=`date "+%Y-%m-%d%n"`
FILE="${UNLOADHOME}/FULL-${CURR_DATE}-PRICE.csv"

  psql << EOF > /dev/null

    TRUNCATE TABLE price_new;

    COPY price_new(
      p_date,
      p_fund,
      p_price)
    FROM '${FILE}'
    DELIMITER ',' CSV HEADER;

EOF
