/*

  EOF_Generate.fun
  Sam Matthews
  24 October 2018

  Function to generate EOM Data for all funds which have more than 100 days of data (3 months)
   - Generate month end data for all funds which have more than 100 daily data points.
   - Add data for additional month. This is the month which will get updated later by another peice of code.
   - Update cursor name ref --> ref_a

  Output --> EOM_Generation
  Input <-- price_new

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);

*/

CREATE OR REPLACE FUNCTION EOM_Generation() RETURNS VOID AS $$

DECLARE
  ref_a RECORD;
  ref_b RECORD;

BEGIN

  RAISE NOTICE 'Populating month end price information.';

  -- We need to remove all data from this table, because this function will re-populate everything from price_new
  TRUNCATE TABLE eom_generation;

  FOR ref_a IN

    SELECT DISTINCT p_fund, count(*)
    FROM price_new
    GROUP BY p_fund
    HAVING count(*) > 100
    ORDER BY 1
    LOOP

      FOR ref_b IN

        SELECT DISTINCT ON (date_trunc('MONTH', p_date))
          date_trunc('MONTH', p_date) AS MONTH,
          p_fund,
          p_price
        FROM price_new
        WHERE p_fund = ref_a.p_fund
        UNION ALL
        SELECT
          DATE_TRUNC('month', MAX(p_date) + INTERVAL '1 MONTH'),
          p_fund,
          p_price
        FROM price_new
        WHERE p_fund = ref_a.p_fund AND p_date = (SELECT MAX(p_date) FROM price_new WHERE p_fund = ref_a.p_fund)
        GROUP BY p_fund, p_price

      LOOP

        INSERT INTO eom_generation(e_date, e_fund, e_price)
        VALUES (ref_b.month, ref_b.p_fund, ref_b.p_price);

      END LOOP;

      -- INSERT additional month.


    END LOOP;

END;
$$ LANGUAGE plpgsql;
