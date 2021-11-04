SELECT * FROM
(SELECT
  a.e_date AS "Start_Date",
  b.e_date AS "End_Date",
  a.e_fund AS Fund,
  -- f.fund_comments,
  -- fs.service_name,
  a.e_price AS "Start_Price",
  b.e_price AS "End_Price",
  -- ROUND(CAST(b.e_price - a.e_price AS NUMERIC),4)/a.e_price AS "Price-Diff",
  --((b.e_price - a.e_price) / a.e_price * 100)  AS "Total Return",
  --b.e_date - a.e_date "Days",
  ROUND(CAST((((b.e_price - a.e_price) / a.e_price * 100) / (b.e_date - a.e_date)) * 365 AS NUMERIC),2) "AReturn"
 FROM
  (SELECT * FROM eom_generation WHERE e_date = (SELECT MAX(e_date) - INTERVAL '24 MONTHS' FROM eom_generation)) a,
  (SELECT * FROM eom_generation WHERE e_date = (SELECT MAX(e_date) FROM eom_generation)) b,
  r_fund f, r_fund_service fs, r_service_portfolio sp
WHERE a.e_fund = b.e_fund
  AND a.e_fund = f.fund_name
  AND f.fund_name = fs.fund_name
  AND fs.service_name = sp.service_name
  -- AND fs.service_name IN ('NZX')
  -- AND sp.portfolio_name = 'KIWISAVER_SAM'
  -- AND sp.portfolio_name = 'HARRY'
  AND sp.portfolio_name = 'SHARESIES'
ORDER BY "AReturn" DESC) a
UNION
SELECT * FROM
(SELECT
  a.p_date AS "Start_Date",
  b.p_date AS "End_Date",
  a.p_fund AS Fund,
  a.p_price AS "Start-Price",
  b.p_price AS "End-Price",
  ROUND(CAST((((b.p_price - a.p_price) / a.p_price * 100) / (b.p_date - a.p_date)) * 365 AS NUMERIC),2) "AReturn"
 FROM
  (SELECT * FROM price_new WHERE p_date = '2019-06-07') a,
  (SELECT * FROM price_new WHERE p_date = (SELECT MAX(p_date) FROM price_new)) b
WHERE a.p_fund = b.p_fund
AND a.p_fund IN ('BOT','USA','JPN','LIV','ESG','EUG','ZNPECT','450002','450007','AGG','450005')
ORDER BY "AReturn" DESC) a
ORDER BY "AReturn" DESC
;
