#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.

#

${HOME}/Code/funds/postgres/load/load-all-data.sh
${HOME}/Code/funds/BIN/load-analytic.sh
