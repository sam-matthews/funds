/*

  EOM-Update-Current-Price.fun
  Sam Matthews
  27 October 2018

  Function to update the last price in the current month.

  1. Create cursor for all funds.
  2. Update EOM_Generation set price = last price in price_new table for current fund in current month.

  Requirements.

  1. Find current month.
  2. Find the most current price.


  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);

  TEST:

  psql
  SELECT FROM EOM_GENERATION();
  SELECT FROM EomUpdateCurrentPrice();

  SELECT * FROM eom_generation WHERE e_fund = 'MPY' ORDER BY e_date DESC LIMIT1;
  SELECT * FROM price_new WHERE p_fund = 'MPY' ORDER BY p_date DESC LIMIT1;

  Ensure price information in the two queries are the same.

  Assuming everything is correct, then run

  psql
  SELECT FROM calcEOMMovement();
  SELECT FROM EomSMA();

  Then verify that all data has been generated.



*/

CREATE OR REPLACE FUNCTION EomUpdateCurrentPrice() RETURNS VOID AS $$

DECLARE
  ref_a   RECORD;
  p_current_price REAL;

BEGIN
  RAISE NOTICE 'Updating current price information.';

  -- We start by genresating a list of all funds.

  FOR ref_a IN
    SELECT DISTINCT e_fund FROM EOM_Generation ORDER BY 1
  LOOP

    -- Find the current or latest price.
    SELECT p_price FROM price_new INTO p_current_price
    WHERE 1=1
      AND p_fund = ref_a.e_fund
      AND p_date <= CURRENT_DATE
    ORDER BY p_date DESC LIMIT 1
    ;

    UPDATE EOM_Generation SET e_price = p_current_price
    WHERE 1=1
      AND e_fund = ref_a.e_fund
      AND e_date = (SELECT e_date FROM EOM_Generation WHERE e_fund = ref_a.e_fund ORDER BY e_date DESC LIMIT 1);

  END LOOP;

END;
$$ LANGUAGE plpgsql;
