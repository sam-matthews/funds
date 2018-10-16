/*

all-fund-data.sql

Sam Matthews
8th October 2018

Create SQL script which will generate current price for all funds.

*/

-- SELECT * FROM price_new WHERE p_date = '05-OCT-2018'
-- ORDER BY p_fund
-- ;

COPY (SELECT * FROM price_new WHERE p_date = '05-OCT-2018' ORDER BY p_fund)
  TO '/Users/sam/Documents/DATA/funds/log/fund-price-data.csv' DELIMITER ',' CSV HEADER;
