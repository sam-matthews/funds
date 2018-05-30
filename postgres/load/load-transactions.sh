#!/bin/bash

APPNAME="funds"
APPHOME="${HOME}/source/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"

DATAHOME=${HOME}/DATA/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

CSVLOADFILE="${LOADHOME}/price-diff/price-diff-s_transactions.csv"

CURR_DATE=`date "+%Y-%m-%d"`

psql << EOF

  DELETE FROM s_transactions;

  COPY s_transactions(
    t_date,
    t_fund,
    t_portfolio,
    t_type,
    t_qty,
    t_comments)
    FROM '$CSVLOADFILE' DELIMITER ',' CSV HEADER;

    INSERT INTO transactions(
      t_date,
      t_fund,
      t_portfolio,
      t_type,
      t_qty,
      t_comments)
    SELECT
      t_date,
      t_fund,
      t_portfolio,
      t_type,
      t_qty,
      t_comments
    FROM
      s_transactions
    EXCEPT
    SELECT
      t_date,
      t_fund,
      t_portfolio,
      t_type,
      t_qty,
      t_comments
    FROM
      transactions
    ;

  COPY (
    SELECT
      t_date,
      t_fund,
      t_portfolio,
      t_type,
      t_qty,
      t_comments
      FROM transactions ORDER BY t_date)
    TO '$UNLOADHOME/FULL-${CURR_DATE}-TRANSACTIONS.csv' DELIMITER ',' CSV HEADER;

EOF

# remove data files older than 10 days.

# Deleting files older than 10 days.
echo "Removing files older than 10 days."
find ${UNLOADHOME} -name 'FULL-*-TRANSACTIONS.csv' -mtime +10 -exec ls -l {} \;

