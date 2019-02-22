#!/bin/bash

#
#  0.3.1.sh
#  Sam Matthews
#  22nd October 2018
#
#  Install 0.3.1 scripts

SQL_HOME="$HOME/Code/funds/postgres/sql"
TABS_HOME="$HOME/Code/funds/postgres/tabs"
FUN_HOME="$HOME/Code/funds/postgres/fun"
LOA_HOME="$HOME/Code/funds/postgres/load"

# Create tables
psql -f ${TABS_HOME}/s_summary-data.tab
psql -f ${TABS_HOME}/summary-data.tab
psql -f ${TABS_HOME}/analytic_lkp.tab
psql -f ${TABS_HOME}/analytic_rep.tab


# Create extentions
psql -f ${SQL_HOME}/extention-crosstab.sql

# Create functions
psql -f ${FUN_HOME}/summary-data.fun
psql -f ${LOA_HOME}/load-sma-fund-data.fun
psql -f ${FUN_HOME}/load_price_to_rep.fun
psql -f ${FUN_HOME}/sma.fun
psql -f ${FUN_HOME}/bollinger.fun
psql -f ${FUN_HOME}/rsi.fun
psql -f ${FUN_HOME}/ema.fun
psql -f ${FUN_HOME}/macd.fun

# Load data into analytic_lkp data.
echo '------------------------------------'
echo 'Load data into analytic_lkp'
psql << EOF
  SELECT FROM load_sma_fund_data();
EOF
