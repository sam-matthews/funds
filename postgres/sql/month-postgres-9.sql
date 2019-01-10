-- month.sql
-- Run to re-generate month end data.
SELECT EOM_Generation();
SELECT EomUpdateCurrentPrice();
SELECT calcEOMMovement();
SELECT EomSMA();

-- Update total for all portfolio funds.

SELECT pop_portfolio_month();
SELECT score();

UPDATE portfolio_price_history
SET p_total = p_perc * (CAST(p_score AS DECIMAL) / 5);




