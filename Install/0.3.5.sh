#!/bin/bash

#
#  0.3.5.sh
#  Sam Matthews
#  10th June 2019
#
#  Install 0.3.5 data

SQL_HOME="$HOME/Code/funds/postgres/sql"
TABS_HOME="$HOME/Code/funds/postgres/tabs"
FUN_HOME="$HOME/Code/funds/postgres/fun"
LOA_HOME="$HOME/Code/funds/postgres/load"

# Create tables

psql -q -t -c "INSERT INTO r_fund('450002','Pathfinder Global Water Fund');"
psql -q -t -c "INSERT INTO r_fund('450005','Pathfinder Global Property Fund');"
psql -q -t -c "INSERT INTO r_fund('450007','Pathfinder Global Responsibility Fund');"
psql -q -t -c "INSERT INTO r_fund('AGG','Global Aggregate Bond Fund');"
psql -q -t -c "INSERT INTO r_fund('BOT','Global Automation & Robotics Fund');"
psql -q -t -c "INSERT INTO r_fund('EMG','Emerging Markets Responsible Fund');"
psql -q -t -c "INSERT INTO r_fund('ESG','Global Responsible Fund');"
psql -q -t -c "INSERT INTO r_fund('EUG','Europe Responsible Fund');"
psql -q -t -c "INSERT INTO r_fund('JPN','Japan Responsible Fund');"
psql -q -t -c "INSERT INTO r_fund('LIV','Global Healthcare Innovation Fund');"
psql -q -t -c "INSERT INTO r_fund('USA','US Responsible Fund');"
psql -q -t -c "INSERT INTO r_fund('ZNPECT','NZ Core Fund');"
