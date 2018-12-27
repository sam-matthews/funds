-- r_fund_service.sql
-- Sam Matthews
-- 27th December 2018

-- Create table to hold fund and service data. This is a resolving table between the fund and service table.

\! echo "======================="
\! echo "Create Table: r_fund_service"

CREATE TABLE IF NOT EXISTS r_fund_service
(
  fund_name CHAR(10),
  service_name CHAR(10),
  fund_service_comments CHAR(200)
);
