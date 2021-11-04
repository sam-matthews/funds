#!/bin/bash

#
#  0.3.3.sh
#  Sam Matthews
#  24rd February 2019
#
#  Install 0.3.3 scripts

APP_BASE="${HOME}/dev/gh/funds"
SQL_HOME="${APP_BASE}/postgres/sql"
TAB_HOME="${APP_BASE}/postgres/tabs"
FUN_HOME="${APP_BASE}/postgres/fun"
LOA_HOME="${APP_BASE}/postgres/load"

# Create tables

# Create functions
psql -f ${FUN_HOME}/rsi.fun
psql -f ${FUN_HOME}/macd.fun
psql -f ${FUN_HOME}/study_score.fun

