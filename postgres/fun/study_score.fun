/*

  study_score.fun
  Sam Matthews
  23 February 2019

  Function to generate a score.

CREATE TABLE IF NOT EXISTS summary_data
(
  s_date      DATE,
  s_fund      CHAR(10),
  s_price     NUMERIC,
  s_sma_6     NUMERIC,
  s_sma_12    NUMERIC,
  s_sma_25    NUMERIC,
  s_sma_50    NUMERIC,
  s_sma_100   NUMERIC,
  s_sma_200   NUMERIC,
  s_bol_mid   NUMERIC,
  s_bol_hig   NUMERIC,
  s_bol_low   NUMERIC,
  s_rsi       NUMERIC,
  s_macd      NUMERIC,
  s_macd_sig  NUMERIC
);



*/

CREATE OR REPLACE FUNCTION study_score() RETURNS VOID AS $$

DECLARE
  ref   RECORD;


  sma_score   INT := 0;
  price_score INT := 0;
  rsi_score   INT := 0;
  bol_score   INT := 0;
  total_score NUMERIC := 0;
  score       INT;
  macd_score  INT;

BEGIN

  RAISE NOTICE 'Starting score routine';
  TRUNCATE TABLE score_data;
  FOR ref IN

    SELECT * FROM summary_data WHERE s_fund NOT IN ('^VIX','UST10YR') ORDER BY s_fund, s_date


  LOOP

    --RAISE NOTICE 'Fund: %', ref.s_fund;
    --RAISE NOTICE 'Date: %', ref.s_date;

    -- initialize some variables
    score := 0;

    -- Calculate price metric. If current price is above s_sma_6 10%
    IF ref.s_price > ref.s_sma_6 THEN score = 10; END IF;

    price_score := score;
    score := 0;

    -- CALCULATE SMA Rainbow 40%
    IF ref.s_sma_6 > ref.s_sma_12 THEN score := score + 2; END IF;
    IF ref.s_sma_12 > ref.s_sma_25 THEN score := score + 2; END IF;
    IF ref.s_sma_25 > ref.s_sma_50 THEN score := score + 2; END IF;
    IF ref.s_sma_50 > ref.s_sma_100 THEN score := score + 2; END IF;
    IF ref.s_sma_100 > ref.s_sma_200 THEN score := score + 2; END IF;

    sma_score := score;
    score := 0;

    -- Calculate Bollinger 15%
    IF ref.s_price BETWEEN ref.s_bol_mid AND ref.s_bol_hig THEN score := 10; END IF;
    IF ref.s_price > ref.s_bol_hig THEN score := 6; END IF;
    IF ref.s_price < ref.s_bol_mid THEN score := 3; END IF;

    bol_score := score;
    score := 0;

    -- Calculate RSI 15%
    IF ref.s_rsi BETWEEN 50 AND 70 THEN score := 10; END IF;
    IF ref.s_rsi BETWEEN 70 AND 100 THEN score := 6; END IF;
    IF ref.s_rsi BETWEEN 30 AND 49 THEN score := 3; END IF;
    IF ref.s_rsi BETWEEN 0 AND 30 THEN score := 0; END IF;


    rsi_score := score;
    score := 0;

    -- Calculate MACD score 20%
    IF ref.s_macd > 0 AND ref.s_macd > ref.s_macd_sig THEN score := 10; END IF;
    IF ref.s_macd > 0 AND ref.s_macd < ref.s_macd_sig THEN score := 6; END IF;
    IF ref.s_macd < 0 AND ref.s_macd > ref.s_macd_sig THEN score := 3; END IF;

    macd_score := score;
    score := 0;

    -- Calculate Score
    total_score := (price_score * 0.10) + (sma_score * 0.40) + (bol_score * 0.15) + (rsi_score * 0.15) + (macd_score * 0.20);

    -- INSERT INTO score_data
    INSERT INTO score_data VALUES (ref.s_date, ref.s_fund, total_score, price_score, sma_score, bol_score, rsi_score, macd_score);
  END LOOP;
END;
$$ LANGUAGE plpgsql;
