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
      INSERT INTO study_bollinger_bands (b_date, b_fund, b_price, b_middle_point, b_high_point, b_low_point)
      SELECT
        p.p_date,
        p.p_fund,
        p.p_price,
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

    -- INSERT specific data into analytic_rep table so Bollinger data can be added to the summary_data.
    INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_value)
    SELECT b_date, b_fund, 'BOL-MIDDLE', b_middle_point FROM study_bollinger_bands;

    INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_value)
    SELECT b_date, b_fund, 'BOL-HIGH', b_high_point FROM study_bollinger_bands;

    INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_value)
    SELECT b_date, b_fund, 'BOL-LOW', b_low_point FROM study_bollinger_bands;

END;
$$ LANGUAGE plpgsql;
