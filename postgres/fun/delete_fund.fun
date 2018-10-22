/*

  delete_fund.sql
  Sam Matthews
  22 October 2018

  Function to delete entries relating to a particular fund.
  Tables to delete from will be:

  price_new
  analytic_lkp
  analytic_rep

  Useage:
  1. Compile function.
  2. SELECT sma(<fund>);



*/

DROP FUNCTION delete_fund(fund CHAR(10));

CREATE OR REPLACE FUNCTION delete_fund(fund CHAR(10)) RETURNS VOID AS $$

DECLARE
  myFundEntries INT;

BEGIN

  -- Check if < 100 records exist
  raise notice 'Checking if > 100 fund entries found in price_new table.';
  SELECT count(*) INTO myFundEntries FROM price_new WHERE p_fund = fund;

  IF (myFundEntries < 100) THEN

    raise notice 'Deleting rows from price_new';
    DELETE FROM price_new WHERE p_fund = fund;

    raise notice 'Deleting rows from analytic_lkp';
    DELETE FROM analytic_lkp WHERE a_fund = fund;

    raise notice 'Deleting rows from analytic_rep';
    DELETE FROM analytic_rep WHERE r_fund = fund;

  ELSE
    raise notice 'Delete this fund manually. There is more than 100 entries in the price table.';
  END IF;

END;
$$ LANGUAGE plpgsql;
