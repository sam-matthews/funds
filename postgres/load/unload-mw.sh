#!/bin/bash

APPHOME="${HOME}/source/Security"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"
UNLOADHOME="${APPHOME}/data/unload/"

for fund in `cat ${CFGHOME}/mw-funds.cfg`
do
  echo $fund

  psql << EOF

    SELECT mw('$fund');

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
