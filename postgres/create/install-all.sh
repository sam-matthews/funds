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

APP_BASE="${HOME}/dev/gh/funds"
SQL_HOME="${APP_BASE}/postgres/sql"
TAB_HOME="${APP_BASE}/postgres/tabs"
FUN_HOME="${APP_BASE}/postgres/fun"
LOA_HOME="${APP_BASE}/postgres/load"
CRE_HOME="${APP_BASE}/postgres/create"

psql  -f ${TAB_HOME}/s_price.tab
psql  -f ${TAB_HOME}/price-new.tab
psql  -f ${TAB_HOME}/s_stock.tab
psql  -f ${TAB_HOME}/analytic_lkp.tab
psql  -f ${TAB_HOME}/analytic_rep.tab
psql  -f ${TAB_HOME}/study_bollinger_bands.tab
psql  -f ${TAB_HOME}/study_rsi.tab
psql  -f ${TAB_HOME}/eom_generation.tab
psql  -f ${TAB_HOME}/portfolio-fund.tab
psql  -f ${TAB_HOME}/portfolio-price-history.tab

# Create reference tables
psql  -f ${TAB_HOME}/r_fund.sql
psql  -f ${TAB_HOME}/r_service.sql
psql  -f ${TAB_HOME}/r_portfolio.sql
psql  -f ${TAB_HOME}/r_fund_service.sql
psql  -f ${TAB_HOME}/r_service_portfolio.sql


# Create functions.

# echo '========================='
# echo 'Create Function: unload_stg_new.fun()'
# psql  -f ${FUN_HOME}/unload-stg-new.fun

# echo '========================='
# echo 'Create Function: load_sma_fund_data()'
# psql  -f ${FUN_HOME}/load-sma-fund-data.fun

echo '========================='
echo 'Create Function: bollinger()'
psql  -f ${FUN_HOME}/bollinger.fun

echo '========================='
echo 'Create Function: sma()'
psql  -f ${FUN_HOME}/sma.fun

echo '========================='
echo 'Create Function: eom_generation()'
psql  -f ${FUN_HOME}/EOM_Generate.fun

echo '========================='
echo 'Create Function: calcEOMMovement()'
psql  -f ${FUN_HOME}/EOM-movement-calculation.fun

# echo '========================='
# echo 'Create Function: EomSMA()'
# psql  -f ${FUN_HOME}/EOM-SMA.fun

echo '========================='
echo 'Create Function: EomUpdateCurrentPrice()'
psql  -f ${FUN_HOME}/EOM-Update-Current-Price.fun

echo '========================='
echo 'Create Function: pop_portfolio_month()'
psql  -f ${FUN_HOME}/pop-portfolio-month.fun

echo '========================='
echo 'Create Function: score()'
psql  -f ${FUN_HOME}/score.fun

# Load Data.
# Load reference data from CSV Data

echo '========================='
echo 'Load Reference Data'
psql -f ${CRE_HOME}/install-reference.sql

# Load Price Data

echo '========================='
echo 'Load Price Data: '
${LOA_HOME}/load-full-postgres.sh

# Load data into analytic_lkp data.

echo '========================='
echo 'Load Data: load_sma_fund_data()'
psql  -f ${SQL_HOME}/load-analytic_lkp.sql

# Load Study data into analytic_rep

echo '========================='
echo 'Load Data: Load SMA Data into analytic_rep'
psql  -f ${SQL_HOME}/load-study-sma.sql

# Load fund and portfolio data intoportfolio_fund table.

echo '========================='
echo 'Load Data: Portfolio_Fund'
psql  -f ${SQL_HOME}/insert-portfolio-fund.sql




