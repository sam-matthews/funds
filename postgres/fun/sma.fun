/*

  sma.fun
  Sam Matthews
  10 October 2018

  Function to output SMA calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

CREATE OR REPLACE FUNCTION sma() RETURNS VOID AS $$

DECLARE
  ref             RECORD;
  mySMA           REAL;
  duplicate_entry INTEGER;

BEGIN

  TRUNCATE TABLE analytic_rep;

  FOR ref IN

    SELECT fund_name FROM r_fund
    LOOP

      -- SELECT simple moving average for each SMA Level
      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        6,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (6-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 6
      ORDER BY p_date;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        12,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (12-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 12
      ORDER BY p_date;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        25,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (25-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 25
      ORDER BY p_date;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        50,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (50-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 50
      ORDER BY p_date;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        100,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (100-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 100
      ORDER BY p_date;

      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        200,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (200-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 200
      ORDER BY p_date;


      -- Used to calculate starting point for Bollinger Bands.
      -- This will not be used in the score function.
      INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_level1, r_value)
      SELECT
        p.p_date,
        p.p_fund,
        l.a_type,
        20,
        AVG(p.p_price) OVER(ORDER BY p,p_date ROWS BETWEEN (20-1) PRECEDING AND CURRENT ROW)
      FROM price_new p, analytic_lkp l
      WHERE 1=1
        AND p.p_fund = l.a_fund
        AND p_fund = ref.fund_name
        AND l.a_type = 'SMA'
        AND CAST(l.a_level1 AS INT) = 20
      ORDER BY p_date;

    END LOOP;

END;
$$ LANGUAGE plpgsql;
