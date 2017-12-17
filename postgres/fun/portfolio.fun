CREATE OR REPLACE FUNCTION gen_portfolio(port_id CHAR(3)) RETURNS VOID AS $$

DECLARE
  r_port RECORD;
  r_date RECORD;

  first_date BOOLEAN;
  current_date DATE;
  s_total REAL;
  s_open  REAL;
  s_low REAL;
  s_high  REAL;
  s_close REAL;

BEGIN

  EXECUTE 'TRUNCATE t_portfolio';

  FOR r_port IN SELECT * FROM portfolio WHERE portfolio_sym = port_id
  LOOP
    INSERT INTO t_portfolio VALUES (r_port.portfolio_sym, r_port.portfolio_fund,0);
  END LOOP;

  -- Find the first date in the cursor.
  SELECT MIN(price_date) INTO current_date
  FROM price a, lkp_type b, portfolio c, lkp_fund d
  WHERE a.price_type1 = b.type_id
    AND a.price_secu = c.portfolio_fund
    AND a.price_secu = d.fund_id
    AND b.type_plan = 'PORTFOLIO'
    AND c.portfolio_sym = port_id;

  FOR r_date IN
  SELECT
    a.price_date,
    a.price_secu,
    a.price_type1,
    a.price_type2,
    a.price_price
  FROM price a, lkp_type b, portfolio c, lkp_fund d
  WHERE a.price_type1 = b.type_id
    AND a.price_secu = c.portfolio_fund
    AND a.price_secu = d.fund_id
    AND b.type_plan = 'PORTFOLIO'
    AND c.portfolio_sym = port_id
  ORDER BY a.price_date, b.id, d.id
  LOOP

    -- IF Date has changed.
    IF (current_date <> r_date.price_date) THEN
      IF first_date = TRUE THEN
        s_open := s_total;
      END IF;
    END IF;

    raise notice '======================================';
    raise notice 'Date: %', r_date.price_date;
    raise notice 'Fund: %', r_date.price_secu;
    raise notice 'Date: %', r_date.price_type1;
    raise notice 'Date: %', r_date.price_price;

  END LOOP;
END;

$$ LANGUAGE plpgsql;
