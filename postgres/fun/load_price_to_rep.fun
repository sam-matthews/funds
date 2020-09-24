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
