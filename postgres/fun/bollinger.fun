/*

  bollinger.fun
  Sam Matthews
  29th January 2019

  Function to output Bollinger calculations for all funds across most dates.

  Usage:
  1. Compile function.
  2. SELECT bollinger(<fund>);



*/

CREATE OR REPLACE FUNCTION bollinger() RETURNS VOID AS $$

DECLARE
  ref             RECORD;
  mySMA           REAL;
  duplicate_entry INTEGER;

BEGIN

  TRUNCATE TABLE study_bollinger_bands;

  FOR ref IN

    SELECT fund_name FROM r_fund
    LOOP

      -- SELECT simple moving average for each SMA Level
      INSERT INTO study_bollinger_bands (b_date, b_fund, b_middle_point, b_high_point, b_low_point)
      SELECT
        p.p_date,
        p.p_fund,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (20-1) PRECEDING AND CURRENT ROW),
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (20-1) PRECEDING AND CURRENT ROW) + 
        	2 * STDDEV(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (20-1) PRECEDING AND CURRENT ROW), 
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (20-1) PRECEDING AND CURRENT ROW) -
        	2 * STDDEV(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (20-1) PRECEDING AND CURRENT ROW) 
      FROM price_new p
      WHERE 1=1
        AND p.p_fund = ref.fund_name
      ORDER BY p_date;

    END LOOP;

END;
$$ LANGUAGE plpgsql;
