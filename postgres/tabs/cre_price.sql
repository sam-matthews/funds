DROP TABLE price;

CREATE TABLE price(
  price_date DATE,
  price_secu CHAR(10),
  price_type1 CHAR(10),
  price_type2 CHAR(10),
  PRICE_PRICE REAL
);

DROP TABLE s_price;

CREATE TABLE s_price(
  s_price_date DATE,
  s_price_open REAL,
  s_price_high REAL,
  s_price_low REAL,
  s_price_close REAL,
  s_price_volume INTEGER,
  s_price_adj REAL
);
