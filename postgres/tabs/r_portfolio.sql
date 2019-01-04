-- r_portfolio.sql
-- Sam Matthews
-- 27th December 2018

-- Create table to hold portfolio reference data.

\! echo "======================="
\! echo "Create Table: r_portfolio"

CREATE TABLE IF NOT EXISTS r_portfolio
(
  portfolio_name CHAR(20),
  portfolio_comments CHAR(200)
);
