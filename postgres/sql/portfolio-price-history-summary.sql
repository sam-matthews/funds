-- sql script to report on eewir]ty balance for each portfolio. 
SELECT p_portfolio, p_date, ROUND(SUM(CAST(p_total AS NUMERIC)),4)
FROM portfolio_price_history
WHERE 1=1
--   AND p_date = '2018-10-01'
GROUP BY p_portfolio, p_date
ORDER BY p_portfolio, p_date
;
