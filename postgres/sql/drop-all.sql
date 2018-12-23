-- drop-all.sql
-- Sam Matthews
-- 23rd December 2018

-- DROP TABLES
DROP TABLE IF EXISTS s_price;
DROP TABLE IF EXISTS price_new;
DROP TABLE IF EXISTS s_stock;
DROP TABLE IF EXISTS analytic_lkp;
DROP TABLE IF EXISTS analytic_rep;
DROP TABLE IF EXISTS eom_generation;
DROP TABLE IF EXISTS portfolio_fund;
DROP TABLE IF EXISTS portfolio_price_history;

-- DROP FUNCTIONS

DROP FUNCTION IF EXISTS load_sma_fund_data() ;


