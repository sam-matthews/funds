CREATE OR REPLACE FUNCTION calculate_total() RETURNS VOID AS $$
DECLARE

  ref_a RECORD;
  total REAL;

BEGIN

  FOR ref_a IN SELECT * FROM portfolio_price_history
  LOOP


    total := CAST(ref_a.p_perc AS REAL) * (CAST(ref_a.p_score AS INT) / 5);

    RAISE NOTICE 'Portfolio: %', ref_a.p_portfolio;
    RAISE NOTICE 'Fund: %', ref_a.p_fund;
    RAISE NOTICE 'Percent: %', ref_a.p_perc;
    RAISE NOTICE 'Score: %', ref_a.p_score;
    RAISE NOTICE 'Total: %', total;

    UPDATE portfolio_price_history SET p_total = total
    WHERE p_date = ref_a.p_date
      AND p_portfolio = ref_a.p_portfolio
      AND p_fund = ref_a.p_fund;

  END LOOP;

END;
$$ LANGUAGE plpgsql;
