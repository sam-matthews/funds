#!/bin/bash

#
#  month.sh
#  Sam Matthews
#  26th October 2018
#
#  Run month scripts (after CSV for daily data has been loaded.

#

echo "EOM_Generation"
psql -c "SELECT FROM EOM_Generation();" -c "\q"

echo "EOM Update Current Price"
psql -c "SELECT FROM EomUpdateCurrentPrice();" -c "\q"

# -- echo "Calc EOM Movement"
# -- psql -c "SELECT FROM calcEOMMovement();" -c "\q"

# -- echo "EOM SMA"
# -- psql -c "SELECT FROM EomSMA();" -c "\q"

# -- echo "POP Portfolio Month"
# psql -c "SELECT FROM pop_portfolio_month();" -c "\q"

# echo "Run Score"
# psql -c "SELECT FROM score();" -c "\q"

# echo "Update price info"
# psql -c "UPDATE portfolio_price_history SET p_total = p_perc * (CAST(p_score AS DECIMAL) / 5);" -c "\q"

