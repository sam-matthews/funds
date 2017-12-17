#!/bin/bash

for file in `ls -1 $HOME/Security/data`
do

  psql << EOF
    -- Truncate Staging Table.
    TRUNCATE TABLE t_price;

    -- Load file into staging table.
    COPY t_price(
      price_date,
      price_open,
      price_high,
      price_low,
      price_close,
      price_volume,
      price_adj_close)
    FROM '$HOME/Security/data/$file' DELIMITER ',' CSV HEADER
    ;

    -- Load data into atomic table.

    INSERT INTO s_price(price_security, price_date, price_open, price_high, price_low, price_close, price_volume, price_adj_close)
    SELECT
      (SELECT security_id FROM lkp_filename WHERE security_name = '$file'),
      price_date,
      price_open,
      price_high,
      price_low,
      price_close,
      price_volume,
      price_adj_close
    FROM
      t_price
    EXCEPT
    SELECT
      price_security,
      price_date,
      price_open,
      price_high,
      price_low,
      price_close,
      price_volume,
      price_adj_close
    FROM
      s_price
    WHERE
      price_security = (SELECT security_id FROM lkp_filename WHERE security_name = '$file')
    ;

EOF

done
