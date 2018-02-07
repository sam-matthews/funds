/*
  unload-all-price.sql
  Sam Matthews
  26th December 2017

  Script to unooad specific data to be loaded into new price data.

*/

TRUNCATE TABLE price_new;

COPY price_new(
    p_date,
    p_fund,
    p_price)
FROM '/Users/sam/Documents/Funds2.0/Prices-Price2.0.csv'
DELIMITER ',' CSV HEADER;
