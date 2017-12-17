
-- Truncate Staging Table.
TRUNCATE TABLE price;

-- Load file into staging table.
COPY price(
  price_date,
  price_secu,
  price_type1,
  price_type2,
  price_price)
FROM '/home/sam/DATA/Security/Investment2.0-Price.csv' DELIMITER ',' CSV HEADER
;
