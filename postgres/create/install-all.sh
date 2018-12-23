#!/bin/bash

# create-postgresql-objects.sql
# Created: 9th December 2018
# Author: Sam Matthews

# Create daily tables

psql  -f ${HOME}/Code/funds/postgres/tabs/s_price.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/price-new.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/s_stock.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/analytic_lkp.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/analytic_rep.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/eom_generation.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/portfolio-fund.tab
psql  -f ${HOME}/Code/funds/postgres/tabs/portfolio-price-history.tab

# Load required lookup Data.

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









