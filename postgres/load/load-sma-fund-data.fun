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

DROP FUNCTION load_sma_fund_data();

CREATE OR REPLACE FUNCTION load_sma_fund_data() RETURNS VOID AS $$
DECLARE
  ref   RECORD;

BEGIN

  DELETE FROM analytic_lkp;
  FOR ref IN

    SELECT DISTINCT p_fund FROM price_new WHERE p_price IS NOT NULL
    LOOP

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.p_fund, 'SMA','6');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.p_fund, 'SMA','12');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.p_fund, 'SMA','25');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.p_fund, 'SMA','50');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.p_fund, 'SMA','100');

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
      VALUES(ref.p_fund, 'SMA','200');

      raise notice '====================================';
      raise notice 'Load SMA data for: %', ref.p_fund;
    END LOOP;

END;
$$ LANGUAGE plpgsql;
