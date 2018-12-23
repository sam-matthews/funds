-- portfolio-price-history1.sql
-- Sam Matthews

/*

  Print list of fund and portfolio information based on the portfolios I have been following.

*/

SELECT
  p_date,
  p_portfolio,
  p_service,
  p_fund,
  ROUND(CAST(p_sma AS NUMERIC),4) AS SMA,
  p_score,
  ROUND(CAST(p_total AS NUMERIC),4) AS TOTAL
FROM portfolio_price_history
WHERE 1=1
  AND p_portfolio IN ('JOINT','TRUST','SAM','KIWI-SAM','KATE')
ORDER BY p_date, p_portfolio, p_fund
;
