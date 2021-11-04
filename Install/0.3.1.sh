#!/bin/bash

#
#  0.3.1.sh
#  Sam Matthews
#  22nd October 2018
#
#  Install 0.3.1 scripts

APP_BASE="${HOME}/dev/gh/funds"
SQL_HOME="${APP_BASE}/postgres/sql"
TAB_HOME="${APP_BASE}/postgres/tabs"
FUN_HOME="${APP_BASE}/postgres/fun"
LOA_HOME="${APP_BASE}/postgres/load"

# Create tables
psql -f ${TAB_HOME}/s_summary-data.tab
psql -f ${TAB_HOME}/summary-data.tab
psql -f ${TAB_HOME}/analytic_lkp.tab
psql -f ${TAB_HOME}/analytic_rep.tab
psql -f ${TAB_HOME}/study_bollinger_bands.tab
psql -f ${TAB_HOME}/r_fund.sql


# Create extentions
# Commented because there is a permiss
# psql -f ${SQL_HOME}/extention-crosstab.sql

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
