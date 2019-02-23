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

CREATE OR REPLACE FUNCTION summary_data() RETURNS VOID AS $$

DECLARE

  ref           RECORD;
  ref_a         RECORD;
  sma_6         NUMERIC;
  sma_12        NUMERIC;
  sma_25        NUMERIC;
  sma_50        NUMERIC;
  sma_100       NUMERIC;
  sma_200       NUMERIC;

BEGIN

--  TRUNCATE TABLE study_summary;
  TRUNCATE TABLE summary_data;

  FOR ref IN

    SELECT fund_name
    FROM r_fund
    WHERE 1=1
      AND fund_name IN ('APA')
    ORDER BY fund_name

  LOOP

    RAISE NOTICE 'FUND: %', ref.fund_name;

    INSERT INTO summary_data
    SELECT * FROM CROSSTAB('
    SELECT r_date, r_level1, ROUND(CAST(r_value AS NUMERIC),4) FROM analytic_rep WHERE r_fund = ''ref.fund_name'' ORDER BY 1, CAST(r_level1 AS INT)')
    AS analytic_rep(r_date date, sma6 NUMERIC, sma12 NUMERIC, sma25 NUMERIC, sma50 NUMERIC, sma100 NUMERIC, sma200 NUMERIC);

  END LOOP;

END;
$$ LANGUAGE plpgsql;
