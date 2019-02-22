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
  fund    RECORD;

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
  -- RAISE NOTICE 'Truncnate table.';

  TRUNCATE TABLE study_rsi;

  FOR fund IN
    SELECT fund_name
    FROM r_fund
    -- WHERE fund_name IN ('APA','MPC','MPD','^NZX50')
    ORDER BY fund_name
  LOOP
    TRUNCATE TABLE s_study_rsi;
    -- Populate RSI Table.

    -- RAISE NOTICE 'Load Data';
    INSERT INTO s_study_rsi
    SELECT
      a.p_fund,
      ROW_NUMBER() over (ORDER BY a.p_date) AS row_number,
      a.p_date,
      a.p_price
    FROM price_new a
    WHERE a.p_fund = fund.fund_name;

    -- Update Difference between data points

    -- RAISE NOTICE 'Update Diff in ??? points';
    UPDATE s_study_rsi SET p_diff = subquery.diff
    FROM
    (
      SELECT a.row_number, a.p_date, a.p_fund, a.p_price, a.p_price-b.p_price AS DIFF
      FROM s_study_rsi a, s_study_rsi b
      WHERE 1=1
        AND a.row_number = b.row_number+1
        AND a.p_fund = b.p_fund
        AND a.p_fund = fund.fund_name
    ) subquery
    WHERE
    s_study_rsi.row_number = subquery.row_number;

    -- Update GAIN and LOSS columns
    UPDATE s_study_rsi
    SET gain =  p_diff, loss=COALESCE(loss,0)
    WHERE p_fund = fund.fund_name AND p_diff > 0;

    --RAISE NOTICE 'Update Loss';
    UPDATE s_study_rsi
    SET loss =  ABS(p_diff), gain=COALESCE(gain,0)
    WHERE p_fund = fund.fund_name AND p_diff < 0;

    --RAISE NOTICE 'Update no change';
    UPDATE s_study_rsi
    SET gain = p_diff, loss = p_diff
    WHERE p_fund = fund.fund_name AND p_diff = 0;

  -- Now we start calculation
    -- RAISE NOTICE 'Calculate RSI';
    FOR ref_a IN SELECT * FROM s_study_rsi WHERE p_fund = fund.fund_name ORDER BY row_number

    LOOP
      -- RAISE NOTICE 'Calculate RSI - Phase 1';
      IF (ref_a.row_number = 16) THEN

        SELECT ROUND(avg(gain),4) INTO r_avg_gain
        FROM s_study_rsi
        WHERE 1=1
          AND p_fund = fund.fund_name
          AND row_number BETWEEN 2 AND 15;

        SELECT ROUND(avg(loss),4) INTO r_avg_loss
        FROM s_study_rsi
        WHERE 1=1
          AND p_fund = fund.fund_name
          AND row_number BETWEEN 2 AND 15;

        UPDATE s_study_rsi
        SET gain_avg = r_avg_gain
        WHERE 1=1
          AND p_fund = fund.fund_name
          AND row_number = ref_a.row_number;

        UPDATE s_study_rsi
        SET loss_avg = r_avg_loss
        WHERE 1=1
          AND p_fund = fund.fund_name
          AND row_number = ref_a.row_number;

        r_prev_avg_gain := r_avg_gain;
        r_prev_avg_loss := r_avg_loss;

      END IF;

      IF (ref_a.row_number > 16) THEN

        r_avg_gain = ROUND((((r_prev_avg_gain*13)+ref_a.gain)/14),4);
        r_avg_loss = ROUND((((r_prev_avg_loss*13)+ref_a.loss)/14),4);

        r_rs = ROUND(r_avg_gain/r_avg_loss,4);
        r_rsi = ROUND(100 - (100 / (1 + r_rs)),4);

        UPDATE s_study_rsi
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

    INSERT INTO study_rsi SELECT * FROM s_study_rsi;
  END LOOP;

  INSERT INTO analytic_rep(r_date, r_fund, r_analytic, r_value)
  SELECT p_date, p_fund, 'RSI', rsi FROM study_rsi;

END;
$$ LANGUAGE plpgsql;
