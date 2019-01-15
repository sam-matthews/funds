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
  echo $fund

  psql << EOF > /dev/null

    SELECT mw_new('$fund');

  \COPY s_stock TO '$UNLOADHOME/MW-20171209-$fund.csv' WITH (FORMAT CSV , HEADER);
  -- \COPY s_stock TO '$HOME/MW-20171209-$fund.csv' WITH (FORMAT CSV , HEADER);

EOF

done
