
# Install script for portfolio tables.

psql -f ${HOME}/Code/funds/postgres/tabs/portfolio-price-history.tab
psql -f ${HOME}/Code/funds/postgres/sql/insert-portfolio-fund.sql




