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
  AND p_portfolio IN ('TRUST','SAM','KIWI-SAM','KATE','JOINT')
  AND p_score > 0
ORDER BY p_date, p_portfolio, p_service,p_fund
;
