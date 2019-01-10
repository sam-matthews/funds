/*

  sma.fun
  Sam Matthews
  10 October 2018

  Function to output SMA calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

CREATE OR REPLACE FUNCTION sma() RETURNS VOID AS $$

DECLARE
  ref             RECORD;
  mySMA           REAL;
  duplicate_entry INTEGER;

BEGIN

  FOR ref IN

    SELECT a_fund, a_type, CAST(a_level1 AS INT) myLevel1
    FROM analytic_lkp
    WHERE 1=1
      -- AND a_fund = fund
      AND a_type = 'SMA'
    LOOP

      -- SELECT simple moving average for each SMA Level
      SELECT AVG(sma.p_price) sma_value INTO mySMA
      FROM
      (
        SELECT *
        FROM price_new
        WHERE p_fund = ref.a_fund AND p_date <= current_date
        ORDER BY p_date DESC LIMIT ref.myLevel1
      ) sma
      GROUP BY sma.p_fund;


      -- Check if this script has already been run today.

      SELECT COUNT(*) INTO duplicate_entry
      FROM analytic_rep
      WHERE 1=1
        AND r_date = current_date
        AND r_fund = ref.a_fund
        AND r_analytic = ref.a_type
        AND CAST(r_level1 AS INT) = ref.myLevel1
      ;

      IF duplicate_entry = 0 THEN

        INSERT INTO analytic_rep(r_date,r_fund,r_analytic,r_level1,r_value)
        VALUES (current_date, ref.a_fund,ref.a_type,ref.myLevel1,mySMA);

      END IF;

    END LOOP;

END;
$$ LANGUAGE plpgsql;
