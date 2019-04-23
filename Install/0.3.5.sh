#!/bin/bash

#
#  0.3.5.sh
#  Sam Matthews
#  23rd April  2019
#
#  Install 0.3.4 scripts

SQL_HOME="$HOME/Code/funds/postgres/sql"
TAB_HOME="$HOME/Code/funds/postgres/tabs"
FUN_HOME="$HOME/Code/funds/postgres/fun"
LOA_HOME="$HOME/Code/funds/postgres/load"

# Create tables
echo "Create tables"
psql -q -t -f ${TAB_HOME}/summary-data.tab
psql -q -t -f ${TAB_HOME}/s_summary-data.tab

# Create functions
echo "Loading Functions"
psql -q -t -f ${LOA_HOME}/load-sma-fund-data.fun
psql -q -t -f ${FUN_HOME}/sma.fun

# Run functions as part of install.
echo "Load updated Lookup Data"
psql -q -t -c "SELECT FROM load_sma_fund_data();"
