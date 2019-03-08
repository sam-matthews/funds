/*

  sma.fun
  Sam Matthews
  27 February 2019

  Function to output STDDEV calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

CREATE OR REPLACE FUNCTION stddev() RETURNS VOID AS $$

DECLARE
  ref             RECORD;
  --mySMA           REAL;
  --duplicate_entry INTEGER;

BEGIN

  DELETE FROM analytic_rep WHERE r_analytic LIKE 'STDDEV%';

  FOR ref IN

    SELECT fund_name FROM r_fund
    LOOP

      -- RAISE NOTICE 'FUND: %', ref.fund_name;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        14,
        ROUND(CAST(STDDEV(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (14-1) PRECEDING AND CURRENT ROW) AS NUMERIC),4)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'STDDEV'
      ORDER BY p_date;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        14,
        ROUND(CAST(p.p_price / STDDEV(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (14-1) PRECEDING AND CURRENT ROW) AS NUMERIC),4) AS "Volitility"
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'VOLATILITY'
      ORDER BY p_date;

    END LOOP;

END;
$$ LANGUAGE plpgsql;
