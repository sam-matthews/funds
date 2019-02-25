-- DROP FUNCTION mw_new(fund CHAR(10));

CREATE OR REPLACE FUNCTION mw_new(fund CHAR(10)) RETURNS VOID AS $$
DECLARE
  ref         RECORD;
  counter     INTEGER;
  close_price REAL;
  high_price  REAL;
  low_price   REAL;

BEGIN
  counter := 0;
  -- raise notice 'Loading: %', fund;

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

END;
$$ LANGUAGE plpgsql;
