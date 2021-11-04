#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.
# A change.


DATA_LOAD_HOME="$HOME/dev/Data/funds/load/price-diff"

echo "Pre Data Load Steps"
if [[ ! -d ${DATA_LOAD_HOME} ]]
then
  echo "ERROR: Directory: ${DATA_LOAD_HOME} does not exist"
  exit 10
fi

${HOME}/dev/gh/funds/postgres/load/load-postgres.sh

# ${HOME}/Code/funds/postgres/load/unload-mw-new.sh


