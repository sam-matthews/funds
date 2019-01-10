-- r_fund.sql
-- Sam Matthews
-- 27th December 2018

-- Create table to hold fund reference data.

\! echo "======================="
\! echo "Create Table: r_fund"

CREATE TABLE IF NOT EXISTS r_fund
(
  fund_name CHAR(10),
  fund_comments CHAR(200)
);
