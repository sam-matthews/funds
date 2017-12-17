
-- Insert data from CSV FIle.

COPY t_price(price_date, price_open, price_high, price_low, price_close, price_volume, price_adj_close)
FROM '/home/sam/Security/data/Milford-Data-Milford-PIE-Balanced-Fund.csv' DELIMITER ',' CSV HEADER
;

-- Insert into atomic table.
INSERT INTO s_price(price_security, price_date, price_open, price_high, price_low, price_close, price_volume, price_adj_close)
SELECT 'MPC', price_date, price_open, price_high, price_low, price_close, price_volume, price_adj_close FROM t_price
;


