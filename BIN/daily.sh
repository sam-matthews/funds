#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.

# echo "Creating directory: mkdir -p ${DATA_LOAD_HOME}"
# mkdir -p ${DATA_LOAD_HOME}

${APP_HOME}/postgres/load/load-postgres.sh

