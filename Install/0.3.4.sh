#!/bin/bash

#
#  0.3.4.sh
#  Sam Matthews
#  27rd February 2019
#
#  Install 0.3.4 scripts

SQL_HOME="$HOME/Code/funds/postgres/sql"
TABS_HOME="$HOME/Code/funds/postgres/tabs"
FUN_HOME="$HOME/Code/funds/postgres/fun"
LOA_HOME="$HOME/Code/funds/postgres/load"

# Create tables

psql -q -t -f ${TABS_HOME}/s_summary-data.tab
psql -q -t -f ${TABS_HOME}/summary-data.tab
psql -q -t -f ${TABS_HOME}/score_data.tab

# Create functions
echo "Loading Functions"
psql -q -t -f ${FUN_HOME}/stddev.fun
psql -q -t -f ${LOA_HOME}/load-sma-fund-data.fun
psql -q -t -f ${FUN_HOME}/study_score.fun

# Run functions as part of install.
echo "Load updated Lookup Data"
psql -q -t -c "SELECT FROM load_sma_fund_data();"

