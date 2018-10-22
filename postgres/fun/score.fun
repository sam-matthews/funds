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

  FOR ref_a IN
  SELECT DISTINCT r_fund FROM analytic_rep ORDER BY r_fund
  LOOP

    -- initialize some variables
    score         := 0;
    loop_counter  := 0;
    stop_sma      := 0;
    start_sma     := 0;


    FOR ref_b IN

    SELECT *
    FROM analytic_rep
    WHERE 1=1
      AND r_fund = ref_a.r_fund
      AND r_analytic = 'SMA'
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

      /*raise notice 'Fund: %', ref_b.r_fund;
      raise notice 'SMA Level: %', ref_b.r_level1;
      raise notice 'start_sma: %', start_sma;
      raise notice 'stop_sma: %', stop_sma;
      raise notice 'Score: %', score;
      raise notice '----------------------------------';*/
    END LOOP;

    raise notice 'Fund: %', ref_a.r_fund;
    raise notice 'Score: %', score;
    raise notice '=================================';
  END LOOP;
END;
$$ LANGUAGE plpgsql;
