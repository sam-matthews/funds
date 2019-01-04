-- r_service_portfolio.sql
-- Sam Matthews
-- 27th December 2018

-- Create table to hold service and portfolio data. This is a resolving table between the service and fund tables.

\! echo "======================="
\! echo "Create Table: r_service_portfolio"

CREATE TABLE IF NOT EXISTS r_service_portfolio
(
  service_name CHAR(20),
  portfolio_name CHAR(20),
  service_portfolio_comments CHAR(200)
);
