/*

  load_price_to_rep.fun
  Sam Matthews
  22 February 2019

  Function to output load_price_to_rep calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT load_price_to_rep(<fund>);



*/

CREATE OR REPLACE FUNCTION load_price_to_rep() RETURNS VOID AS $$

BEGIN

  DELETE FROM analytic_rep WHERE r_analytic = 'PRICE';

  INSERT INTO analytic_rep (r_date, r_fund, r_analytic, r_value)
  SELECT
     p.p_date,
     p.p_fund,
     'PRICE',
     p.p_price
  FROM price_new p
  JOIN analytic_lkp l ON l.a_fund = p.p_fund
  WHERE l.a_type = 'PRICE';

END;
$$ LANGUAGE plpgsql;
