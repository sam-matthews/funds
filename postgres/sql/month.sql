-- month.sql
-- Run to re-generate month end data.
SELECT FROM EOM_Generation();
SELECT FROM EomUpdateCurrentPrice();
SELECT FROM calcEOMMovement();
SELECT FROM EomSMA();

-- Update total for all portfolio funds.

SELECT FROM pop_portfolio_month();
SELECT FROM score();

UPDATE portfolio_price_history
SET p_total = p_perc * (CAST(p_score AS DECIMAL) / 5);




