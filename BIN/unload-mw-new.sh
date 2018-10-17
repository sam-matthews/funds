#!/bin/bash

APPNAME="funds"
APPHOME="${HOME}/source/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"

DATAHOME=${HOME}/DATA/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

for fund in `cat ${CFGHOME}/mw-funds.cfg`
do
  echo $fund

  psql << EOF > /dev/null

    SELECT mw_new('$fund');

    COPY (
    SELECT
      s_stock_date      date,
      s_stock_open      open,
      s_stock_high      high,
      s_stock_low       low,
      s_stock_close     "close",
      s_stock_volume    volume,
      s_stock_adj_close "adj close"
    FROM s_stock ORDER BY s_stock_date)
    TO '$UNLOADHOME/MW-20171209-$fund.csv' DELIMITER ',' CSV HEADER;

    \q

EOF

done
