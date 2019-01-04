-- drop-all.sql
-- Sam Matthews
-- 23rd December 2018

/*
Modifications
  4th Jan 2019: SMM : Added Drop Function commands
*/

-- DROP Daily and Monthly tables.

DROP TABLE IF EXISTS s_price;
DROP TABLE IF EXISTS price_new;
DROP TABLE IF EXISTS s_stock;
DROP TABLE IF EXISTS analytic_lkp;
DROP TABLE IF EXISTS analytic_rep;
DROP TABLE IF EXISTS eom_generation;
DROP TABLE IF EXISTS portfolio_fund;
DROP TABLE IF EXISTS portfolio_price_history;

-- DROP Reference Tables

DROP TABLE IF EXISTS r_fund;
DROP TABLE IF EXISTS r_service;
DROP TABLE IF EXISTS r_portfolio;
DROP TABLE IF EXISTS r_fund_service;
DROP TABLE IF EXISTS r_service_portfolio;

-- Drop Functions

DROP FUNCTION IF EXISTS calceommovement();
DROP FUNCTION IF EXISTS eom_generation();
DROP FUNCTION IF EXISTS eomsma();
DROP FUNCTION IF EXISTS eomupdatecurrentprice();
DROP FUNCTION IF EXISTS load_sma_fund_data();
DROP FUNCTION IF EXISTS pop_portfolio_month();
DROP FUNCTION IF EXISTS score();
DROP FUNCTION IF EXISTS sma();



