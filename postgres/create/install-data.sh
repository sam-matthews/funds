#!/bin/bash

# create-postgresql-objects.sql
# Created: 9th December 2018
# Author: Sam Matthews

# Create daily tables

psql  -f ${HOME}/Code/funds/postgres/tabs/price-new.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/s_price.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/s_stock.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/analytic_lkp.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/analytic_rep.tab

# Load required lookup Data.

psql  -f ${HOME}/Code/funds/postgres/load/load-sma-fund-data.fun




