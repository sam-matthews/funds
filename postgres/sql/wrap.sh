#!/bin/bash

PORTFOLIO=$1
SERVICE=$2

echo ${PORTFOLIO}
echo ${SERVICE}

psql << EOF
SELECT a.* FROM
(SELECT
  a.p_date AS "Start_Date",
  b.p_date AS "End_Date",
  a.p_fund AS Fund,
  a.p_price AS "Start_Price",
  b.p_price AS "End_Price",
  c.r_value AS "SMA-500",
  ROUND(CAST((((b.p_price - a.p_price) / a.p_price * 100) / (b.p_date - a.p_date)) * 365 AS NUMERIC),2) "AReturn"
 FROM
  (SELECT * FROM price_new WHERE p_date = (SELECT CURRENT_DATE - INTERVAL '24 MONTHS')) a,
  (SELECT * FROM price_new WHERE p_date = (SELECT CURRENT_DATE)) b,
  (SELECT * FROM analytic_rep WHERE r_date = (SELECT CURRENT_DATE) AND r_analytic = 'SMA-500') c
  WHERE a.p_fund = b.p_fund AND b.p_fund = c.r_fund
  UNION
  SELECT
    a.p_date AS "Start_Date",
    b.p_date AS "End_Date",
    a.p_fund AS Fund,
    a.p_price AS "Start-Price",
    b.p_price AS "End-Price",
    NULL,
    ROUND(CAST((((b.p_price - a.p_price) / a.p_price ) / (b.p_date - a.p_date)) * 365 * 100 AS NUMERIC),2) "AReturn"
  FROM
    (SELECT * FROM price_new WHERE p_date = '2019-06-07') a, -- start date for listed funds.
    (SELECT * FROM price_new WHERE p_date = (SELECT CURRENT_DATE)) b
    -- r_fund f, r_fund_service fs, r_service_portfolio sp
  WHERE a.p_fund = b.p_fund
    AND a.p_fund IN ('BOT','USA','JPN','LIV','ESG','EUG','ZNPECT','450002','450007','AGG','450005')
) a,
r_fund f, r_fund_service fs, r_service_portfolio sp
WHERE a.fund = f.fund_name
  AND f.fund_name = fs.fund_name
  AND fs.service_name = sp.service_name
  AND sp.portfolio_name = '&PORTFOLIO'
  AND fs.service_name = '&SERVICE'
ORDER BY 7 DESC
;
EOF
