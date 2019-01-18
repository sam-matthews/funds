#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.

DATA_LOAD_HOME="$HOME/Data/funds/load/price-diff"

if [[ ! -d ${DATA_LOAD_HOME} ]]
then 
  echo "Creating directory: mkdir -p ${DATA_LOAD_HOME}"
  mkdir -p ${DATA_LOAD_HOME}
fi

cp -p $HOME/Code/funds/Data/price-diff-s_price.csv ${DATA_LOAD_HOME}

${HOME}/Code/funds/postgres/load/load-postgres.sh
${HOME}/Code/funds/postgres/load/unload-mw-new.sh


