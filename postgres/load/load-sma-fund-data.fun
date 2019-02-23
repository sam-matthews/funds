/*

  sma.sql
  Sam Matthews
  10 October 2018

  Function to output SMA calculations. Input is anaytic_lkp and price data.
  Output will (eventually into a seperate table).

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);

*/

CREATE OR REPLACE FUNCTION load_sma_fund_data() RETURNS VOID AS $$
DECLARE
  ref   RECORD;

BEGIN

  TRUNCATE TABLE analytic_lkp;
  FOR ref IN

    SELECT DISTINCT fund_name FROM r_fund ORDER BY fund_name
    LOOP
      -- Data for price.
      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'PRICE',1);

      -- Data for SMA
      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence, a_level1)
      VALUES(ref.fund_name, 'SMA-6',11,6);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence, a_level1)
      VALUES(ref.fund_name, 'SMA-12',12,12);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence, a_level1)
      VALUES(ref.fund_name, 'SMA-25',13,25);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence, a_level1)
      VALUES(ref.fund_name, 'SMA-50',14,50);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence, a_level1)
      VALUES(ref.fund_name, 'SMA-100',15,100);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence, a_level1)
      VALUES(ref.fund_name, 'SMA-200',16,200);

      -- Data for Bolllinger

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'BOL-MIDDLE',21);


      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'BOL-HIGH',22);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'BOL-LOW',23);

      -- Data for RSI

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'RSI',31);

      -- MACD

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'MACD',32);

      INSERT INTO analytic_lkp(a_fund, a_type, a_sequence)
      VALUES(ref.fund_name, 'MACD-SIGNAL',33);

      INSERT INTO analytic_lkp(a_fund, a_type, a_level1, a_level2) VALUES (ref.fund_name, 'EMA', 12, 0.1538);
      INSERT INTO analytic_lkp(a_fund, a_type, a_level1, a_level2) VALUES (ref.fund_name, 'EMA', 26, 0.0741);


    END LOOP;

END;
$$ LANGUAGE plpgsql;
