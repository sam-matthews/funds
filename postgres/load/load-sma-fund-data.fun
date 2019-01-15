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

CREATE OR REPLACE FUNCTION load_sma_fund_data() RETURNS VOID AS $$
DECLARE
  ref   RECORD;

BEGIN

  TRUNCATE TABLE analytic_lkp;
  FOR ref IN

    SELECT DISTINCT fund_name FROM r_fund
    LOOP

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'SMA','6');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'SMA','12');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'SMA','25');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'SMA','50');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'SMA','100');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'SMA','200');

      -- Determine Bollinger Bands

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.fund_name, 'BOLLINGER','20');

    END LOOP;

END;
$$ LANGUAGE plpgsql;
