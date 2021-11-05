#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.
# A change.

DATA_LOAD_HOME="${DATA_HOME}/load/price-diff"

echo "Pre Data Load Steps"
if [[ ! -d ${DATA_LOAD_HOME} ]]
then
  echo "ERROR: Directory: ${DATA_LOAD_HOME} does not exist"
  exit 10
fi

echo "Running load-postgres.sh"

${APP_HOME}/postgres/load/load-postgres.sh

