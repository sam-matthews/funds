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

CREATE OR REPLACE FUNCTION rsi() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  ref_b   RECORD;
  -- mySMA REAL;
  loop_counter INT :=0;

  r_avg_gain NUMERIC;
  r_avg_loss NUMERIC;

  r_prev_avg_gain NUMERIC;
  r_prev_avg_loss NUMERIC;

  r_rs NUMERIC;
  r_rsi NUMERIC;

  -- start_sma REAL := 0;
  -- stop_sma REAL := 0;

  -- score INT := 0;

BEGIN

  RAISE NOTICE 'Starting RSI routine';

  -- TRUNCATE TABLE
  RAISE NOTICE 'Truncnate table.';
  TRUNCATE TABLE study_rsi_apa_test;

  -- Populate RSI Table.
  RAISE NOTICE 'Load Data';
  INSERT INTO study_rsi_apa_test
  SELECT
  ROW_NUMBER() over (ORDER BY a.p_date) AS row_number,
  a.p_date,
  a.p_fund,
  a.p_price
  FROM price_new a
  WHERE a.p_fund = 'APA';

  -- Update Difference between data points
  RAISE NOTICE 'Update Diff in ??? points';
  UPDATE study_rsi_apa_test SET p_diff = subquery.diff
  FROM
  (
    SELECT a.row_number, a.p_date, a.p_fund, a.p_price, a.p_price-b.p_price AS DIFF
    FROM study_rsi_apa_test a, study_rsi_apa_test b
    WHERE a.row_number = b.row_number+1
  ) subquery
  WHERE
    study_rsi_apa_test.row_number = subquery.row_number;

  -- Update GAIN and LOSS columns
  RAISE NOTICE 'Update gain and loss columns';
  UPDATE study_rsi_apa_test SET gain =  p_diff, loss=COALESCE(loss,0) WHERE p_diff > 0;
  UPDATE study_rsi_apa_test SET loss =  ABS(p_diff), gain=COALESCE(gain,0) WHERE p_diff < 0;
  UPDATE study_rsi_apa_test SET gain = 0, loss = 0 WHERE p_diff = 0;

  -- Now we start calculation
  FOR ref_a IN SELECT * FROM study_rsi_apa_test WHERE p_fund = 'APA' ORDER BY row_number

  LOOP

    IF (ref_a.row_number = 16) THEN

      RAISE NOTICE 'CREATE SMA for last 14 periods';
      RAISE NOTICE 'ROW NUMBER: %', ref_a.row_number;


      SELECT ROUND(avg(gain),4) INTO r_avg_gain FROM study_rsi_apa_test WHERE row_number BETWEEN 2 AND 15;
      SELECT ROUND(avg(loss),4) INTO r_avg_loss FROM study_rsi_apa_test WHERE row_number BETWEEN 2 AND 15;

      RAISE NOTICE 'r_avg_gain = %', r_avg_gain;
      RAISE NOTICE 'r_avg_loss = %', r_avg_loss;

      UPDATE study_rsi_apa_test SET gain_avg = r_avg_gain WHERE row_number = ref_a.row_number AND p_fund = 'APA';
      UPDATE study_rsi_apa_test SET loss_avg = r_avg_loss WHERE row_number = ref_a.row_number AND p_fund = 'APA';

      r_prev_avg_gain := r_avg_gain;
      r_prev_avg_loss := r_avg_loss;

    END IF;

    IF (ref_a.row_number > 16) THEN
      RAISE NOTICE 'CREATE EMS for last 14 periods';
      RAISE NOTICE 'ROW NUMBER: %', ref_a.row_number;
      RAISE NOTICE 'r_prev_avg_gain: %', r_prev_avg_gain;
      RAISE NOTICE 'r_prev_avg_loss: %', r_prev_avg_loss;
      RAISE NOTICE 'ref_a.gain: %', ref_a.gain;
      RAISE NOTICE 'ref_a.loss: %', ref_a.loss;


      r_avg_gain = ROUND((((r_prev_avg_gain*13)+ref_a.gain)/14),4);
      r_avg_loss = ROUND((((r_prev_avg_loss*13)+ref_a.loss)/14),4);

      r_rs = ROUND(r_avg_gain/r_avg_loss,4);
      r_rsi = ROUND(100 - (100 / (1 + r_rs)),4);

      RAISE NOTICE 'r_avg_gain = %', r_avg_gain;
      RAISE NOTICE 'r_avg_loss = %', r_avg_loss;
      RAISE NOTICE 'r_rs = %', r_rs;
      RAISE NOTICE 'r_rsi = %', r_rsi;

      UPDATE study_rsi_apa_test
      SET
        gain_avg = r_avg_gain,
        loss_avg = r_avg_loss,
        rs=r_rs,
        rsi=r_rsi
      WHERE row_number = ref_a.row_number;

      r_prev_avg_gain := r_avg_gain;
      r_prev_avg_loss := r_avg_loss;

    END IF;

  END LOOP;

END;
$$ LANGUAGE plpgsql;
