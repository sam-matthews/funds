/*

  EOM-SMA.fun
  Sam Matthews
  24 October 2018

  Function to output SMA calculations FOR EOM DATA.

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

CREATE OR REPLACE FUNCTION EomSMA() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  ref_b   RECORD;

  mySMA       REAL;
  mySMALevel  INT := 18;
  myCounter   INT := 0;


BEGIN
  RAISE NOTICE 'Gathering Month End SMA 500 Data';

  -- We start by generating a list of all funds.

  FOR ref_a IN
    SELECT DISTINCT e_fund FROM EOM_Generation ORDER BY 1
  LOOP
    -- initialize some variables for each fund.
    myCounter := 0;

    FOR ref_b IN
      SELECT * FROM EOM_Generation
      WHERE 1=1
        AND e_fund = ref_a.e_fund
      ORDER BY e_date

    LOOP
      -- initialize some variables for each fund.

      UPDATE EOM_Generation SET e_sma_500 =
      (
        SELECT r_value
        FROM analytic_rep
        WHERE 1=1
          AND r_fund = ref_b.e_fund
          AND r_date = ref_b.e_date
          AND mySMA
        WHERE 1=1
          AND e_fund = ref_a.e_fund
          AND e_date = ref_b.e_date;

      END IF;

      myCounter := myCOunter + 1;

    END LOOP;

  END LOOP;

END;
$$ LANGUAGE plpgsql;
