/*

  EOM-movement-calculation.fun
  Sam Matthews
  22 October 2018

  INPUT --> EOM_Generation
  OUTPUT --> EOM_Generation.e_diff

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);

*/

CREATE OR REPLACE FUNCTION calcEOMMovement() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  ref_b   RECORD;
  -- mySMA REAL;
  loop_counter INT :=0;
  start_calc REAL;
  stop_calc REAL;
  diff_calc REAL;

BEGIN

  RAISE NOTICE 'Running difference calculations between each month.';

  FOR ref_a IN
    SELECT DISTINCT e_fund e_fund FROM EOM_Generation ORDER BY e_fund
  LOOP

    -- initialize some variables
    loop_counter := 0;
    stop_calc    := 0;
    start_calc   := 0;
    diff_calc    := 0;

    FOR ref_b IN

      SELECT * FROM EOM_Generation
      WHERE 1=1
        AND e_fund = ref_a.e_fund
      ORDER BY e_date
    LOOP

      loop_counter := loop_counter + 1;

      IF (loop_counter = 1) THEN

        start_calc := ref_b.e_price;

      ELSE

        stop_calc  := start_calc;
        start_calc := ref_b.e_price;
        diff_calc  := (start_calc - stop_calc)/stop_calc;

        -- raise notice 'Date: %', ref_b.e_date;
        -- raise notice 'Fund: %', ref_b.e_fund;
        -- raise notice 'Diff: %', diff_calc;


        UPDATE EOM_Generation
        SET e_diff = diff_calc
        WHERE 1=1
          AND e_date = ref_b.e_date
          AND e_fund = ref_b.e_fund;

      END IF;

    END LOOP;

  END LOOP;
END;
$$ LANGUAGE plpgsql;
