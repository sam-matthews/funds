/*

  all_analytic.sql
  Sam Matthews
  10 October 2018

  Function to run analytics for all available funds.

  Useage:
  1. Compile function.
  2. SELECT all_analytic();



*/

DROP FUNCTION all_analytic();

CREATE OR REPLACE FUNCTION all_analytic() RETURNS VOID AS $$
DECLARE
  ref   RECORD;

BEGIN

  FOR ref IN

    SELECT DISTINCT p_fund FROM price_new order by 1
    LOOP

      SELECT FROM sma(ref.p_fund);

    END LOOP;

END;
$$ LANGUAGE plpgsql;
