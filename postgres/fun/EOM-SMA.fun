/*

  EOM-SMA.fun
  Sam Matthews
  24 October 2018

  Function to output SMA calculations FOR EOM DATA.

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

DROP FUNCTION EomSma();

CREATE OR REPLACE FUNCTION EomSMA() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  ref_b   RECORD;

  mySMA       REAL;
  mySMALevel  INT := 18;
  myCounter   INT := 0;


BEGIN
  -- We start by genresating a list of all funds.

  FOR ref_a IN
    SELECT DISTINCT e_fund FROM EOM_Generation ORDER BY 1
  LOOP
    -- initialize some variables for each fund.
    myCounter := 0;

    raise notice 'Fund: %', ref_a.e_fund;

    FOR ref_b IN
      SELECT * FROM EOM_Generation
      WHERE 1=1
        AND e_fund = ref_a.e_fund
      ORDER BY e_date
    LOOP
      -- initialize some variables for each fund.
      IF myCounter > 1 THEN
        raise notice 'Date: %', ref_b.e_date;
        raise notice 'Fund: %', ref_b.e_fund;
        raise notice 'Price: %', ref_b.e_price;
        raise notice 'Diff: %', ref_b.e_diff;

        SELECT AVG(sma.e_diff) sma_diff INTO mySMA
        FROM
        (
          SELECT *
          FROM EOM_Generation
          WHERE e_fund = ref_a.e_fund AND e_date <= ref_b.e_date
          ORDER BY e_date DESC LIMIT mySMALevel
        ) sma
        GROUP BY sma.e_fund;

        UPDATE EOM_Generation SET e_sma = mySMA
        WHERE 1=1
          AND e_fund = ref_a.e_fund
          AND e_date = ref_b.e_date;

      END IF;

      myCounter := myCOunter + 1;

    END LOOP;

  END LOOP;

END;
$$ LANGUAGE plpgsql;
