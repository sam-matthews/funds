/*

  score.fun
  Sam Matthews
  22 October 2018

  Function to generate a score.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

DROP FUNCTION score();

CREATE OR REPLACE FUNCTION score() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  ref_b   RECORD;
  -- mySMA REAL;
  loop_counter INT :=0;

  start_sma REAL := 0;
  stop_sma REAL := 0;

  score INT := 0;

BEGIN

  RAISE NOTICE 'Starting score routine';

  FOR ref_a IN
    SELECT DISTINCT p_fund FROM portfolio_price_history ORDER BY p_fund
  LOOP

    -- RAISE NOTICE 'Fund: %', ref_a.p_fund;

    -- initialize some variables
    score         := 0;
    loop_counter  := 0;
    stop_sma      := 0;
    start_sma     := 0;


    FOR ref_b IN

      SELECT *
      FROM analytic_rep
      WHERE 1=1
        AND r_fund = ref_a.p_fund
        AND r_analytic = 'SMA'
        AND r_date = (
          SELECT r_date
          FROM analytic_rep
          WHERE r_fund = ref_a.p_fund
          ORDER BY r_date DESC LIMIT 1)
      ORDER BY CAST(r_level1 AS INT) DESC
    LOOP

      loop_counter := loop_counter + 1;

      IF (loop_counter = 1) THEN

        start_sma := ref_b.r_value;

      ELSE

        stop_sma := start_sma;
        start_sma := ref_b.r_value;

        IF (start_sma - stop_sma > 0) THEN
          score := score + 1;
        END IF;

      END IF;

    END LOOP;

    -- Update the score for the most recent record for the given fund

    UPDATE portfolio_price_history
    SET p_score = score
    WHERE 1=1
      AND p_date =
      (
        SELECT p_date FROM portfolio_price_history
        WHERE p_fund = ref_a.p_fund ORDER BY p_date DESC LIMIT 1
      )
      AND p_fund = ref_a.p_fund;

  END LOOP;
END;
$$ LANGUAGE plpgsql;
