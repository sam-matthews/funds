    DROP FUNCTION mw(fund CHAR(10));

CREATE OR REPLACE FUNCTION mw(fund CHAR(10)) RETURNS VOID AS $$
DECLARE
  ref         RECORD;
  counter     INTEGER;
  close_price REAL;
  high_price  REAL;
  low_price   REAL;

BEGIN
  counter := 0;
  raise notice'Loading data into Stage Table.';
  raise notice 'Delete Table: s_stock';
  -- TRUNCATE TABLE s_stock;
  DELETE FROM s_stock;


  FOR ref IN
    SELECT
      price_date,
      price_secu,
      price_type1,
      price_type2,
      price_price
  FROM price
  WHERE price_secu = fund AND price_type1 = 'PRI'
  ORDER BY price_date
  LOOP
    counter := counter + 1;

    -- If first record
    IF counter = 1 then
      raise notice '========================';
      raise notice 'date:%',ref.price_date;
      raise notice 'open:%',ref.price_price;
      raise notice 'high:%',ref.price_price;
      raise notice 'low:%',ref.price_price;
      raise notice 'close:%',ref.price_price;

      INSERT INTO s_stock VALUES(
        ref.price_date,
        ref.price_price,
        ref.price_price,
        ref.price_price,
        ref.price_price,
        0,
        ref.price_price
      );

      ELSE
        -- Check what is the high price and what is the low price.
        IF close_price < ref.price_price THEN
          low_price := close_price;
          high_price := ref.price_price;
        ELSE
          low_price := ref.price_price;
          high_price := close_price;
        END IF;

        raise notice '========================';
        raise notice 'date:%',  ref.price_date;
        raise notice 'open:%',  close_price;
        raise notice 'high:%',  high_price;
        raise notice 'low:%',   low_price;
        raise notice 'close:%', ref.price_price;

        INSERT INTO s_stock VALUES(
          ref.price_date,
          close_price,
          high_price,
          low_price,
          ref.price_price,
          0,
          ref.price_price
      );


    END IF;
    close_price := ref.price_price;

  END LOOP;

  raise notice 'Count: %', counter;

END;
$$ LANGUAGE plpgsql;
