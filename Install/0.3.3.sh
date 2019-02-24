#!/bin/bash

#
#  0.3.3.sh
#  Sam Matthews
#  24rd February 2019
#
#  Install 0.3.3 scripts

SQL_HOME="$HOME/Code/funds/postgres/sql"
TABS_HOME="$HOME/Code/funds/postgres/tabs"
FUN_HOME="$HOME/Code/funds/postgres/fun"
LOA_HOME="$HOME/Code/funds/postgres/load"

# Create tables

# Create functions
psql -f ${FUN_HOME}/rsi.fun
psql -f ${FUN_HOME}/macd.fun
psql -f ${FUN_HOME}/study_score.fun

