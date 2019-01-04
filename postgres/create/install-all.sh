#!/bin/bash

# create-postgresql-objects.sql
# Created: 9th December 2018
# Author: Sam Matthews

# Create daily tables

# Order of installation.

# 1. Create Tables.
# 2. Create Functions.

# 3. Load Data

# - Reference Data
# - Price Data
# - Lookup Data

psql  -f ${HOME}/Code/funds/postgres/tabs/s_price.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/price-new.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/s_stock.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/analytic_lkp.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/analytic_rep.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/eom_generation.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/portfolio-fund.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/portfolio-price-history.tab

# Create reference tables
psql  -f ${HOME}/Code/funds/postgres/tabs/r_fund.sql
psql  -f ${HOME}/Code/funds/postgres/tabs/r_service.sql
psql  -f ${HOME}/Code/funds/postgres/tabs/r_portfolio.sql
psql  -f ${HOME}/Code/funds/postgres/tabs/r_fund_service.sql
psql  -f ${HOME}/Code/funds/postgres/tabs/r_service_portfolio.sql


# Create functions.
echo '========================='
echo 'Create Function: load_sma_fund_data()'
psql  -f ${HOME}/Code/funds/postgres/load/load-sma-fund-data.fun

echo '========================='
echo 'Create Function: sma()'
psql  -f ${HOME}/Code/funds/postgres/fun/sma.fun

echo '========================='
echo 'Create Function: eom_generation()'
psql  -f ${HOME}/Code/funds/postgres/fun/EOM_Generate.fun

echo '========================='
echo 'Create Function: calcEOMMovement()'
psql  -f ${HOME}/Code/funds/postgres/fun/EOM-movement-calculation.fun

echo '========================='
echo 'Create Function: EomSMA()'
psql  -f ${HOME}/Code/funds/postgres/fun/EOM-SMA.fun

echo '========================='
echo 'Create Function: EomUpdateCurrentPrice()'
psql  -f ${HOME}/Code/funds/postgres/fun/EOM-Update-Current-Price.fun

echo '========================='
echo 'Create Function: pop_portfolio_month()'
psql  -f ${HOME}/Code/funds/postgres/fun/pop-portfolio-month.fun

echo '========================='
echo 'Create Function: score()'
psql  -f ${HOME}/Code/funds/postgres/fun/score.fun

# Load Data.
# Load reference data from CSV Data
echo '========================='
echo 'Load Reference Data'
psql -f ${HOME}/Code/funds/postgres/load/load-reference.sql

# Load Price Data
echo '========================='
echo 'Load Price Data: '
${HOME}/Code/funds/postgres/load/load-full-postgres.sh

# Load data into analytic_lkp data.
echo '========================='
echo 'Load Data: load_sma_fund_data()'
psql  -f ${HOME}/Code/funds/postgres/sql/load-analytic_lkp.sql

# Load Study data into analytic_rep

echo '========================='
echo 'Load Data: Load SMA Data into analytic_rep'
psql  -f ${HOME}/Code/funds/postgres/sql/load-study-sma.sql

# Load fund and portfolio data intoportfolio_fund table.

echo '========================='
echo 'Load Data: Portfolio_Fund'
psql  -f ${HOME}/Code/funds/postgres/sql/insert-portfolio-fund.sql




