#!/bin/bash


DB_HOME="${APP_HOME}/postgres"
CFG_HOME="${DB_HOME}/cfg"

UNLOAD_HOME="${DATA_HOME}/unload"
LOAD_HOME="${DATA_HOME}/load"

for fund in `cat ${CFG_HOME}/mw-funds.cfg`
do
  # echo $fund

  psql << EOF > /dev/null

    SELECT mw_new('$fund');

  \COPY (SELECT \
	s_stock_date AS date, \
	s_stock_open AS open, \
	s_stock_high AS high, \
	s_stock_low AS low, \
	s_stock_close AS close, \
	s_stock_volume AS volume,\
	s_stock_adj_close AS adj_close\
  FROM s_stock)\
  TO '$UNLOAD_HOME/$fund.csv' WITH (FORMAT CSV , HEADER);

EOF

done
