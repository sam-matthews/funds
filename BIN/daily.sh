#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.

#

unzip -o ${HOME}/Code/funds/price-diff.zip -d ${HOME}/Documents/DATA/funds/load/price-diff
${HOME}/Code/funds/postgres/load/load-postgres.sh
${HOME}/Code/funds/postgres/load/unload-mw-new.sh


