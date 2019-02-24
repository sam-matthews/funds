#!/bin/bash

APPNAME="funds"
APPHOME="${HOME}/Code/${APPNAME}"
DBHOME="${APPHOME}/postgres"
CFGHOME="${DBHOME}/cfg"

DATAHOME=${HOME}/Data/${APPNAME}
UNLOADHOME="${DATAHOME}/unload"
LOADHOME="${DATAHOME}/load"

# Truncate summary table.

psql << EOF > /dev/null

  TRUNCATE TABLE summary_data;
EOF


for fund in `cat ${CFGHOME}/mw-funds.cfg`
do
  # echo $fund

  psql << EOF > /dev/null

    TRUNCATE TABLE s_summary_data;

    INSERT INTO s_summary_data
    SELECT * FROM CROSSTAB('SELECT r_date, r_analytic, ROUND(CAST(r_value AS NUMERIC),4)
    FROM analytic_rep rep
    JOIN analytic_lkp lkp
      ON lkp.a_fund = rep.r_fund
     AND lkp.a_type = rep.r_analytic
    WHERE 1=1
      AND lkp.a_fund = ''$fund''
    ORDER BY rep.r_date, lkp.a_sequence')
    AS analytic_rep(
      r_date    DATE,
      price     NUMERIC,
      sma6    NUMERIC,
      sma12     NUMERIC,
      sma25     NUMERIC,
      sma50     NUMERIC,
      sma100    NUMERIC,
      sma200    NUMERIC,
      s_bol_mid   NUMERIC,
      s_bol_hig   NUMERIC,
      s_bol_low   NUMERIC,
      s_rsi       NUMERIC,
      s_macd      NUMERIC,
      s_macd_sig  NUMERIC );

    INSERT INTO summary_data (
      s_date,
      s_fund,
      s_price,
      s_sma_6,
      s_sma_12,
      s_sma_25,
      s_sma_50,
      s_sma_100,
      s_sma_200,
      s_bol_mid,
      s_bol_hig,
      s_bol_low,
      s_rsi,
      s_macd,
      s_macd_sig)
    SELECT
      s_date,
      '$fund',
      s_price,
      s_sma_6,
      s_sma_12,
      s_sma_25,
      s_sma_50,
      s_sma_100,
      s_sma_200,
      s_bol_mid,
      s_bol_hig,
      s_bol_low,
      s_rsi,
      s_macd,
      s_macd_sig
    FROM s_summary_data;

EOF

done
