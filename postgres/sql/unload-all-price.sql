/*
  unload-all-price.sql
  Sam Matthews
  26th December 2017

  Script to unooad specific data to be loaded into new price data.

*/

  COPY (
    SELECT
      price_date,
      price_secu,
      price_price
    FROM price WHERE price_type1 = 'PRI'
    ORDER BY price_date)
    TO '/Users/sam/DATA/funds/unload/funds2.0-price-unload.csv' DELIMITER ',' CSV HEADER;
