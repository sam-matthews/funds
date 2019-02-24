/*

  load-staging.sql
  Sam Matthews
  23rd February 2019

*/

INSERT INTO price_new(p_date,p_fund,p_price)
SELECT sp_date, sp_fund, sp_price FROM s_price
EXCEPT
SELECT p_date, p_fund, p_price FROM price_new;
