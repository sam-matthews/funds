#!/bin/bash

#
#  0.3.2.sh
#  Sam Matthews
#  23rd February 2019
#
#  Install 0.3.2 scripts

APP_BASE="${HOME}/dev/gh/funds"
SQL_HOME="${APP_BASE}/postgres/sql"
TAB_HOME="${APP_BASE}/postgres/tabs"
FUN_HOME="${APP_BASE}/postgres/fun"
LOA_HOME="${APP_BASE}/postgres/load"

# Create tables
psql -f ${TAB_HOME}/score_data.tab


# Create functions
psql -f ${FUN_HOME}/study_score.fun
psql -f ${FUN_HOME}/ema.fun
psql -f ${FUN_HOME}/unload_stg_new.fun
