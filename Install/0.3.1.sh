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

${SQL_HOME}/extention-crosstab.sql
${TABS_HOME}/summary-data.tab
${FUN_HOME}/summary-data.fun

