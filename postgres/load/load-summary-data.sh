#!/bin/bash


DB_HOME="${APP_HOME}/postgres"
CFG_HOME="${DB_HOME}/cfg"

UNLOAD_HOME="${DATA_HOME}/unload"
LOAD_HOME="${DATA_HOME}/load"

# Truncate summary table.

psql << EOF > /dev/null

  TRUNCATE TABLE summary_data;
EOF


for fund in `cat ${CFG_HOME}/mw-funds.cfg`
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
      r_date        DATE,
      price         NUMERIC,
      sma5          NUMERIC,
      sma10         NUMERIC,
      sma20         NUMERIC,
      sma50         NUMERIC,
      sma100        NUMERIC,
      sma200        NUMERIC,
      sma500        NUMERIC);

    INSERT INTO summary_data (
      s_date,
      s_fund,
      s_price,
      s_sma_5,
      s_sma_10,
      s_sma_20,
      s_sma_50,
      s_sma_100,
      s_sma_200,
      s_sma_500)
    SELECT
      s_date,
      '$fund',
      s_price,
      s_sma_5,
      s_sma_10,
      s_sma_20,
      s_sma_50,
      s_sma_100,
      s_sma_200,
      s_sma_500
    FROM s_summary_data;

EOF

done
