/*

  rsi.fun
  Sam Matthews
  2nd February 2019

  Function to generate RSI Data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT FROM rsi();

*/

CREATE OR REPLACE FUNCTION macd() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  fund    RECORD;
  -- mySMA REAL;

  signal_curr NUMERIC;
  signal_prev NUMERIC;

BEGIN

  RAISE NOTICE 'Starting MACD routine';

  -- TRUNCATE TABLE
  -- RAISE NOTICE 'Truncnate table.';

  TRUNCATE TABLE study_macd;

  FOR fund IN
    SELECT fund_name
    FROM r_fund
    WHERE 1=1
      -- AND fund_name IN ('APA')
    ORDER BY fund_name
  LOOP
    --RAISE NOTICE '---------------------';
    --RAISE NOTICE 'Fund Name: %', fund.fund_name;
    -- Populate RSI Table.

    FOR ref_a IN
      SELECT
        a.ema_row_number,
        a.ema_date,
        a.ema_fund,
        a.ema_price AS price,
        a.ema_value AS EMA12,
        b.ema_value AS EMA26,
        a.ema_value - b.ema_value AS MACD
      FROM ema a, ema b
      WHERE a.ema_row_number = b.ema_row_number
        AND a.ema_date = b.ema_date
        AND a.ema_fund = b.ema_fund
        AND a.ema_level = 12
        AND b.ema_level = 26
        AND a.ema_fund = fund.fund_name

    LOOP


      IF ref_a.ema_row_number = 1 THEN

        signal_curr := ref_a.macd;

      ELSE

        signal_curr :=  ROUND((((ref_a.macd - signal_prev) * 0.2) + signal_prev),4);

      END IF;

      INSERT INTO study_macd(
        row_number,
        p_date,
        p_fund,
        p_price,
        ema_12,
        ema_26,
        macd_line,
        signal)
      VALUES(
        ref_a.ema_row_number,
        ref_a.ema_date,
        ref_a.ema_fund,
        ref_a.price,
        ref_a.ema12,
        ref_a.ema26,
        ref_a.macd,
        signal_curr
        );

      signal_prev := signal_curr;

    END LOOP;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
