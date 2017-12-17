/*
    portfolio.sql
    sql script to generate portfolio details.
*/

DROP TABLE portfolio;
CREATE TABLE portfolio(
    portfolio_name CHAR(30),
    portfolio_sym  CHAR(3),
    portfolio_fund CHAR(3)
);

DROP TABLE t_portfolio;
CREATE TABLE t_portfolio(
    t_port_id CHAR(3),
    t_fund_id CHAR(3),
    t_fund_tot REAL);

INSERT INTO portfolio
VALUES (
    'Kate Healy Family Trust',
    'KFT',
    'MPC'
    );

INSERT INTO portfolio
VALUES (
    'Kate Healy Family Trust',
    'KFT',
    'MPD'
    );

INSERT INTO portfolio
VALUES (
    'Kate Healy Family Trust',
    'KFT',
    'MPB'
    );


INSERT INTO portfolio
VALUES (
    'Kate Healy Family Trust',
    'KFT',
    'MPG'
    );


INSERT INTO portfolio
VALUES (
    'Kate Healy Family Trust',
    'KFT',
    'MPT'
    );

INSERT INTO portfolio
VALUES (
    'Kate Healy Family Trust',
    'KFT',
    'MPY'
    );

DROP FUNCTION gen_portfolio(port_id CHAR(3));

CREATE OR REPLACE FUNCTION gen_portfolio(port_id CHAR(3)) RETURNS VOID AS $$
DECLARE
    r_port          RECORD;
    r_date          RECORD;
    fund            CHAR(10);
    balance         REAL;

    s_date          DATE;
    s_open          REAL;
    s_high          REAL;
    s_low           REAL;
    s_close         REAL;
    s_volume        INTEGER;
    s_adj_close     REAL;

    first_record    BOOLEAN;
    current_date    DATE;
BEGIN
    first_record := TRUE;

    -- Truncate the t_portfolio table.
    EXECUTE 'TRUNCATE t_portfolio';

    -- Populate contents of temp table.
    FOR r_port IN SELECT * FROM portfolio WHERE portfolio_sym = port_id
    LOOP
        INSERT INTO t_portfolio VALUES (ref.portfolio_sym, portfolio_fund,0);
    END LOOP;

    -- Find the first date
    SELECT MIN(price_date) INTO current_date
    FROM price a, lkp_type b, portfolio c, lkp_fund d
    WHERE a.price_type1 = b.type_id
        AND a.price_secu = c.portfolio_fund
        AND a.price_secu = d.fund_id
        AND b.type_plan = 'PORTFOLIO'
        AND c.portfolio_sym = port_id;

    -- Now the work begins
    FOR r_date IN
    SELECT
        a.price_date,
        a.price_secu,
        c.portfolio_name,
        b.type_id,
        a.price_price
    FROM price a, lkp_type b, portfolio c, lkp_fund d
    WHERE a.price_type1 = b.type_id
        AND a.price_secu = c.portfolio_fund
        AND a.price_secu = d.fund_id
        AND b.type_plan = 'PORTFOLIO'
        AND c.portfolio_sym = port_id
    ORDER BY a.price_date, b.id, d.id
    LOOP

        IF (r_date.price_date > current_date OR first_record) THEN

            IF first_record THEN
                s_close := r_date.price_price;
                s_open := r_date.price_price;
                s_high := s_close;
                s_low := s_close;
                first_record := FALSE;
            ELSE

                s_open := s_close; -- Set open to the prev close.
                s_close := r_date.price_price; -- set close to the current price.

                IF r_date.price_price < s_close THEN
                    s_high := s_close;
                    s_low := r_date.price_price;
                ELSE
                    s_high := r_date.price_price;
                    s_low := s_close;
                END IF;

            END IF;

            INSERT INTO s_stock VALUES (current_date, s_open, s_high, s_low, s_close, 0, s_close);

        END IF;

    END LOOP;
    SELECT * FROM price -- portfolio_fund
    WHERE 1=1
      AND price_secu IN (
        SELECT portfolio_fund
        FROM portfolio
        WHERE portfolio_sym = port_id)
      AND price_type1 IN ('BUY','SELL','PRI','DIV')
    ORDER BY price_date
    LOOP
        FOR r_fund IN SELECT * FROM price WHERE price_date = r_date.price_date AND
        -- Grab the current trans into a local variable.
        SELECT t_fund_tot INTO fund_tot
        FROM t_portfolio
        WHERE portfolio_fund = ref.price_secu;

        IF ref.price_type1 = 'BUY' THEN
            t_fund_tot := t_fund_tot + ref.price_price;
        END IF;

        IF ref.price_type1 = 'SELL' THEN
            t_fund_tot := t_fund_tot + ref.price_price;
        END IF;

        IF (balance > 0) THEN

            s_price := ref.price_price;
            s_close := s_price * balance;
            s_date := ref.price_date;

            IF (first_line = TRUE) THEN
                s_open := s_close;
                s_high := s_close;
                s_low  := s_close;
                s_adj_close := s_close;
                first_line := FALSE;
            ELSE
                IF ref.price_price < s_close THEN
                    s_high := s_close;
                    s_low := ref.price_price;
                ELSE
                    s_high := ref.price_price;
                    s_low := s_close;
                END IF;

            END IF;

            INSERT INTO s_stock
            VALUES(s_date, s_open, s_high,s_close,0,s_close);

        END IF;

            -- raise notice 'Current balance: %', balance;
    END LOOP;

    raise notice 'Fund: %', fund;
    raise notice 'Balance: %', balance;
    raise notice 'Close: %',s_close;

    END LOOP;

END;


$$ LANGUAGE plpgsql;

SELECT gen_portfolio('KFT');
