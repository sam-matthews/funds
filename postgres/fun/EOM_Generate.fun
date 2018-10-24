/*

  EOF_Generate.fun
  Sam Matthews
  24 October 2018

  Function to generate EOM Data for all funds which have more than 100 days of data (3 months)
  Output --> EOM_Generation
  Input <-- price_new

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);

*/

CREATE OR REPLACE FUNCTION EOM_Generation() RETURNS VOID AS $$

DECLARE
  ref   RECORD;
  ref_b RECORD;

BEGIN

  FOR ref IN

    SELECT DISTINCT p_fund, count(*) FROM price_new GROUP BY p_fund HAVING count(*) > 100 ORDER BY 1
    LOOP
      FOR ref_b IN SELECT DISTINCT ON (date_trunc('MONTH', p_date))
          date_trunc('MONTH', p_date) AS MONTH,
          p_fund,
          p_price
      FROM price_new
      WHERE p_fund = ref.p_fund
      ORDER BY 1
      LOOP
        INSERT INTO eom_generation(e_date, e_fund, e_price) VALUES (ref_b.month, ref_b.p_fund, ref_b.p_price);
      END LOOP;
    END LOOP;

END;
$$ LANGUAGE plpgsql;
