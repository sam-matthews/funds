-- r_service.sql
-- Sam Matthews
-- 27th December 2018

-- Create table to hold fund reference data.

\! echo "======================="
\! echo "Create Table: r_service"

CREATE TABLE IF NOT EXISTS r_service
(
  service_name CHAR(10),
  service_comments CHAR(200)
);
