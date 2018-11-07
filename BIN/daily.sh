#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.

#

${HOME}/Code/funds/postgres/load/load-postgres.sh
${HOME}/Code/funds/postgres/load/unload-mw-new.sh


