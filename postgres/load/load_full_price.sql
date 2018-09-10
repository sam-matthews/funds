
-- Truncate Staging Table.
TRUNCATE TABLE price_new;

-- Load file into staging table.
COPY price_new(
  p_date,
  p_fund,
  p_price)
FROM '/Users/sam/DATA/funds/unload/FULL-2018-09-09-PRICE.csv' DELIMITER ',' CSV HEADER
;
