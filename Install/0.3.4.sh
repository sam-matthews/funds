#!/bin/bash

#
#  0.3.4.sh
#  Sam Matthews
#  27rd February 2019
#
#  Install 0.3.4 scripts

APP_BASE="${HOME}/dev/gh/funds"
SQL_HOME="${APP_BASE}/postgres/sql"
TAB_HOME="${APP_BASE}/postgres/tabs"
FUN_HOME="${APP_BASE}/postgres/fun"
LOA_HOME="${APP_BASE}/postgres/load"

# Create tables

psql -q -t -f ${TAB_HOME}/s_summary-data.tab
psql -q -t -f ${TAB_HOME}/summary-data.tab
psql -q -t -f ${TAB_HOME}/score_data.tab

# Create functions
echo "Loading Functions"
psql -q -t -f ${FUN_HOME}/stddev.fun
psql -q -t -f ${LOA_HOME}/load-sma-fund-data.fun
psql -q -t -f ${FUN_HOME}/study_score.fun

# Run functions as part of install.
echo "Load updated Lookup Data"
psql -q -t -c "SELECT FROM load_sma_fund_data();"

