DROP FUNCTION mw_new(fund CHAR(10));

CREATE OR REPLACE FUNCTION mw_new(fund CHAR(10)) RETURNS VOID AS $$
DECLARE
  ref         RECORD;
  counter     INTEGER;
  close_price REAL;
  high_price  REAL;
  low_price   REAL;

BEGIN
  counter := 0;
  raise notice 'Loading data into Stage Table.';
  raise notice 'Delete Table: s_stock';
  -- TRUNCATE TABLE s_stock;
  DELETE FROM s_stock;


  FOR ref IN
    SELECT
      p_date,
      p_fund,
      p_price
  FROM price_new
  WHERE p_fund = fund
  ORDER BY p_date
  LOOP
    counter := counter + 1;

    -- If first record
    IF counter = 1 then
      raise notice '========================';
      raise notice 'date:%',ref.p_date;
      raise notice 'open:%',ref.p_price;
      raise notice 'high:%',ref.p_price;
      raise notice 'low:%',ref.p_price;
      raise notice 'close:%',ref.p_price;

      INSERT INTO s_stock VALUES(
        ref.p_date,
        ref.p_price,
        ref.p_price,
        ref.p_price,
        ref.p_price,
        0,
        ref.p_price
      );

      ELSE
        -- Check what is the high price and what is the low price.
        IF close_price < ref.p_price THEN
          low_price := close_price;
          high_price := ref.p_price;
        ELSE
          low_price := ref.p_price;
          high_price := close_price;
        END IF;

        raise notice '========================';
        raise notice 'date:%',  ref.p_date;
        raise notice 'open:%',  close_price;
        raise notice 'high:%',  high_price;
        raise notice 'low:%',   low_price;
        raise notice 'close:%', ref.p_price;

        INSERT INTO s_stock VALUES(
          ref.p_date,
          close_price,
          high_price,
          low_price,
          ref.p_price,
          0,
          ref.p_price
      );


    END IF;
    close_price := ref.p_price;

  END LOOP;

  raise notice 'Count: %', counter;

END;
$$ LANGUAGE plpgsql;
