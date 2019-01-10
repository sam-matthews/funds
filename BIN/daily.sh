#!/bin/bash

#
#  daily.sh
#  Sam Matthews
#  22nd October 2018
#
#  Run daily scripts (after CSV for daily data has been loaded.

# Removed unzip command. I'm moving away from storing binary files in my GIT project.

-- unzip -o ${HOME}/Code/funds/price-diff.zip -d ${HOME}/Data/funds/load/price-diff
${HOME}/Code/funds/postgres/load/load-postgres.sh
${HOME}/Code/funds/postgres/load/unload-mw-new.sh


