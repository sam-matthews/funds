#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.
# A change.

DATA_LOAD_HOME="${FUNDS_DAT}/load/price-diff"
FUNDS_LOAD="${FUNDS_APP}/postgres/load"
FUNDS_BIN="${FUNDS_APP}/BIN"

echo "Pre Data Load Steps"
if [[ ! -d ${DATA_LOAD_HOME} ]]
then
  echo "ERROR: Directory: ${DATA_LOAD_HOME} does not exist"
  exit 10
fi

echo "Running load-postgres.sh"

${FUNDS_LOAD}/load-postgres.sh

