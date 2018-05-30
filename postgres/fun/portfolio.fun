CREATE OR REPLACE FUNCTION gen_portfolio(port_id CHAR(10)) RETURNS VOID AS $$

DECLARE
  r_trans RECORD;
  r_port RECORD;
  r_date RECORD;

  first_date BOOLEAN;
  current_date DATE;
  t_total REAL;
  s_open  REAL;
  s_low   REAL;
  s_high  REAL;
  s_close REAL;
  p_buy   REAL;
  t_buy   REAL;

  counter REAL;

BEGIN

  t_buy := 0;
  counter := 0;
  t_total := 0;

  FOR r_price IN
    SELECT
      p_date,
      p_fund,
      p_price
    FROM
      price_new
    ORDER BY t_date
  LOOP

    SELECT IF r_trans.t_type = 'Buy' THEN
      t_total := t_total + r_trans.t_qty;
    ELSE
      t_total := t_total - r_trans.t_qty;
    END IF;

    raise notice 'Date: %', r_trans.t_date;
    raise notice 'Fund: %', r_trans.t_fund;
    raise notice 'Qty: %', r_trans.t_qty;
    raise notice 'Type: %', r_trans.t_type;
    raise notice '=========================================';

  END LOOP;

    raise notice 'Total Qty: %', t_total;

END;

$$ LANGUAGE plpgsql;
