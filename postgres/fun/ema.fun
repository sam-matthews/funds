/*

  ema.fun
  Sam Matthews
  5th February 2018

  Function to output SMA calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT ena(<fund>);



*/

CREATE OR REPLACE FUNCTION ema() RETURNS VOID AS $$

DECLARE

  ref           RECORD;
  ref_a         RECORD;
  my_ema        NUMERIC;
  ema_previous  NUMERIC;
  ema_current   NUMERIC;
  -- ema_period    INT := 10;
  alpha         NUMERIC;

BEGIN

  TRUNCATE TABLE ema;
  -- alpha := 0.1818;

  FOR ref IN

    SELECT a.fund_name AS fund_name, b.a_level1 AS a_level1, b.a_level2 AS a_level2
    FROM r_fund a
    JOIN analytic_lkp b ON a.fund_name = b.a_fund
    WHERE 1=1
      AND b.a_type = 'EMA'
      --AND a.fund_name = 'APA'

  LOOP

    -- SELECT simple moving average for each SMA Level
    --RAISE NOTICE '----------------------------';
    --RAISE NOTICE 'FUND: %', ref.fund_name;
    -- RAISE NOTICE 'EMA LEVEL: %', ref.a_level1;

    FOR ref_a IN

      SELECT row_number() OVER (), p_date, p_fund, p_price
      FROM price_new
      WHERE 1=1
        AND p_fund = ref.fund_name

    LOOP



      IF ref_a.row_number = 1 THEN

        ema_current := ref_a.p_price;

        --RAISE NOTICE 'INSERT when row number is 1.';
        --RAISE NOTICE 'EMA_CURRENT = %', ema_current;
        --RAISE NOTICE 'Current Price = %', ref_a.p_price;

        INSERT INTO ema (
          ema_row_number,
          ema_date,
          ema_fund,
          ema_price,
          ema_level,
          ema_value)
          VALUES(
          ref_a.row_number,
          ref_a.p_date,
          ref_a.p_fund,
          ref_a.p_price,
          ref.a_level1,
          ema_current);

        ELSE

          ema_current := ROUND(CAST(((ref_a.p_price - ema_previous) * ref.a_level2) + ema_previous AS NUMERIC),4);

          --RAISE NOTICE 'EMA_CURRENT = %', ema_current;
          --RAISE NOTICE 'Current Price = %', ref_a.p_price;
          --RAISE NOTICE 'EMA_PREVIOUS = %', ema_previous;

          INSERT INTO ema (
            ema_row_number,
            ema_date,
            ema_fund,
            ema_price,
            ema_level,
            ema_value)
          VALUES(
            ref_a.row_number,
            ref_a.p_date,
            ref_a.p_fund,
            ref_a.p_price,
            ref.a_level1,
            ema_current);

        END IF;

        ema_previous := ema_current;

      END LOOP;

    END LOOP;

END;
$$ LANGUAGE plpgsql;
