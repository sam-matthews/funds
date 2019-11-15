/*

  EOM_SMA.fun
  Sam Matthews
  14 August 2019

  Changing the way SOM data is being generated. I am not completely confident that the SOM price data has been calculated correctly.

  Generally speaking there is data for the 1st of each month for each fund. However sometimes there is not, so with this algorithm I will be looking for data on the 2nd or the end of the previous month.

  I could look at doing it a different way. Basically if it is a Saturday then I look for the previous day. If it is a Sunday then I look for the Monday.

  Had a thought. For each month, run a sub-query, or a query within the loop which will return the first record of the month.


*/

CREATE OR REPLACE FUNCTION EOM_Generation() RETURNS VOID AS $$

DECLARE
  ref_a RECORD;
  ref_b RECORD;

  current_date DATE;
  current_price REAL;

BEGIN

  RAISE NOTICE 'Populating month end price information.';

  -- We need to remove all data from this table, because this function will re-populate everything from price_new
  TRUNCATE TABLE eom_generation;

  FOR ref_a IN

    -- SELECT a list of all of the funds we want to work with.
    SELECT DISTINCT p_fund, count(*)
    FROM price_new WHERE p_fund = 'APA'
    GROUP BY p_fund
    HAVING count(*) > 100
    ORDER BY 1
    LOOP

      FOR ref_b IN

        SELECT * FROM weekdays ORDER BY date
        LOOP
          current_date = ref_b.date;

          -- Determine what date to use.
          IF ref_b.day = 'sat' THEN
            current_date := current_date + 2;
          ELSIF ref_b.day = 'sun' THEN
            current_date := current_date +1;
          ELSE
            current_date = current_date;
          END IF;

          -- Find the price to use.
          SELECT p_price INTO current_price
          FROM price_new
          WHERE 1=1
            AND p_fund = ref_a.p_fund
            AND p_date = current_date;

          -- INSERT Data into EOM Table.
          INSERT INTO eom_generation (e_date, e_fund, e_price)
          VALUES (ref_b.date, ref_a.p_fund, current_price);

        END LOOP;

    END LOOP;

END;
$$ LANGUAGE plpgsql;
