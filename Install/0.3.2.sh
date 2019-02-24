#!/bin/bash

#
#  0.3.2.sh
#  Sam Matthews
#  23rd February 2019
#
#  Install 0.3.2 scripts

SQL_HOME="$HOME/Code/funds/postgres/sql"
TABS_HOME="$HOME/Code/funds/postgres/tabs"
FUN_HOME="$HOME/Code/funds/postgres/fun"
LOA_HOME="$HOME/Code/funds/postgres/load"

# Create tables
psql -f ${TABS_HOME}/score_data.tab


# Create functions
psql -f ${FUN_HOME}/study_score.fun
psql -f ${FUN_HOME}/ema.fun
psql -f ${FUN_HOME}/unload_stg_new.fun
