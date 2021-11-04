#!/bin/bash

#
#  0.3.5.sh
#  Sam Matthews
#  10th June 2019
#
#  Install 0.3.5 data

APP_BASE="${HOME}/dev/gh/funds"
SQL_HOME="${APP_BASE}/postgres/sql"
TAB_HOME="${APP_BASE}/postgres/tabs"
FUN_HOME="${APP_BASE}/postgres/fun"
LOA_HOME="${APP_BASE}/postgres/load"

# Create tables

# psql -q -t -c "INSERT INTO r_fund('450002','Pathfinder Global Water Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('450005','Pathfinder Global Property Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('450007','Pathfinder Global Responsibility Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('AGG','Global Aggregate Bond Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('BOT','Global Automation & Robotics Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('EMG','Emerging Markets Responsible Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('ESG','Global Responsible Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('EUG','Europe Responsible Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('JPN','Japan Responsible Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('LIV','Global Healthcare Innovation Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('USA','US Responsible Fund')"
psql -q -t -c "INSERT INTO r_fund VALUES ('ZNPECT','NZ Core Fund')"
