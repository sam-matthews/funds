#!/bin/bash

APPNAME="funds"
APPHOME="${HOME}/Code/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"

DATAHOME=${HOME}/Data/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

for fund in `cat ${CFGHOME}/mw-funds.cfg`
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
  TO '$UNLOADHOME/MW-20171209-$fund.csv' WITH (FORMAT CSV , HEADER);

EOF

done
