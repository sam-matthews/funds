CREATE OR REPLACE FUNCTION pop_portfolio_month() RETURNS VOID AS $$
DECLARE

  ref_a   RECORD;
  ref_b   RECORD;
  total   REAL;

  sma_floor NUMERIC := 0.0025;

BEGIN

  RAISE NOTICE 'pop_portfolio_month()';

  FOR ref_a IN
    -- Generate list of portfolios.
    SELECT DISTINCT portfolio FROM portfolio_fund
  LOOP

    -- Find sum across all portfolios.
    SELECT SUM(e.e_sma) INTO total
    FROM eom_generation e
    JOIN portfolio_fund p ON e.e_fund = p.fund
    WHERE 1=1
      AND p.portfolio = ref_a.portfolio
      AND e.e_fund IN
      (
        SELECT e_fund
        FROM eom_generation e
        JOIN portfolio_fund p ON e.e_fund = p.fund
        WHERE 1=1
          AND p.portfolio = ref_a.portfolio
          AND e_sma > sma_floor
          AND e_date = (SELECT e_date FROM eom_generation ORDER BY e_date DESC LIMIT 1)
      )
      AND e_date = (SELECT e_date FROM eom_generation ORDER BY e_date DESC LIMIT 1);

        -- Now scan each fund and calculate percent.
    FOR ref_b IN

      SELECT
        e.e_date e_date,
        p.portfolio p_portfolio,
        e.e_fund e_fund,
        p.service p_service,
        e.e_sma e_sma
      FROM eom_generation e
      JOIN portfolio_fund p ON p.fund = e.e_fund
      WHERE 1=1
        AND p.portfolio = ref_a.portfolio
        AND e.e_fund IN
        (
          SELECT e_fund
          FROM eom_generation e
          JOIN portfolio_fund p ON e.e_fund = p.fund
          WHERE 1=1
            AND p.portfolio = ref_a.portfolio
            AND e_sma > sma_floor
            AND e_date = (SELECT e_date FROM eom_generation ORDER BY e_date DESC LIMIT 1)
        )
        AND e_date = (SELECT e_date FROM eom_generation ORDER BY e_date DESC LIMIT 1)

    LOOP

      -- Calculate percent
      -- Delete current record if it currently exists.

      DELETE FROM portfolio_price_history
      WHERE 1=1
        AND p_date = ref_b.e_date
        AND p_portfolio = ref_a.portfolio
        AND p_fund = ref_b.e_fund
      ;

      INSERT INTO portfolio_price_history
      (
        p_date,
        p_portfolio,
        p_service,
        p_fund,
        p_sma,
        p_perc
      )
      VALUES
      (
        ref_b.e_date,
        ref_a.portfolio,
        ref_b.p_service,
        ref_b.e_fund,
        ref_b.e_sma,
        (ref_b.e_sma/total)
      );

      -- RAISE NOTICE 'Portfolio: %', ref_a.portfolio;
      -- RAISE NOTICE 'Fund: %', ref_b.e_fund;
      -- RAISE NOTICE 'Percent: %', ref_b.e_sma/total;

    END LOOP;

  END LOOP;

END
$$ LANGUAGE plpgsql;
