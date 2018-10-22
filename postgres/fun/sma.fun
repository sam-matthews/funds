/*

  sma.sql
  Sam Matthews
  10 October 2018

  Function to output SMA calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

DROP FUNCTION sma();

CREATE OR REPLACE FUNCTION sma() RETURNS VOID AS $$

DECLARE
  ref   RECORD;
  mySMA REAL;


BEGIN

  FOR ref IN

    SELECT a_fund, a_type, CAST(a_level1 AS INT) myLevel1
    FROM analytic_lkp
    WHERE 1=1
      -- AND a_fund = fund
      AND a_type = 'SMA'
    LOOP

      SELECT AVG(sma.p_price) sma_value INTO mySMA
      FROM
      (
        SELECT *
        FROM price_new
        WHERE p_fund = ref.a_fund AND p_date <= current_date
        ORDER BY p_date DESC LIMIT ref.myLevel1
      ) sma
      GROUP BY sma.p_fund;

      /*raise notice 'FUND: %', ref.a_fund;
      raise notice 'Analytic: %', ref.a_type;
      raise notice 'Analytic Level: %', ref.myLevel1;
      raise notice 'SMA Moving average: %', mySMA;
      raise notice '====================================';
*/
      /*
        Send output to analytic_rep

        r_date      DATE
        r_fund      CHAR(10)
        r_analytic  CHAR(10)
        r_level1    CHAR(3)
        r_value     REAL

      */

      INSERT INTO analytic_rep(r_date,r_fund,r_analytic,r_level1,r_value)
      VALUES (current_date, ref.a_fund,ref.a_type,ref.myLevel1,mySMA);

    END LOOP;

END;
$$ LANGUAGE plpgsql;
