#!/bin/bash

DBHOME="${APP_HOME}/postgres"
CFGHOME="${DBHOME}/cfg"

UNLOADHOME="${DATA_HOME}/unload"
LOADHOME="${DATA_HOME}/load"

for fund in `cat ${CFGHOME}/mw-funds.cfg`
do
  
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
  TO '$UNLOADHOME/$fund.csv' WITH (FORMAT CSV , HEADER);

EOF

done
