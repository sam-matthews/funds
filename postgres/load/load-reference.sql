-- load_reference.sql
-- Sam Matthews
-- 27th December 2018

-- Load all reference Data into r_* tables. These are the reference tables.

-- Truncate tables so we don't get duplicate records.
TRUNCATE TABLE r_fund;
TRUNCATE TABLE r_service;
TRUNCATE TABLE r_portfolio;
TRUNCATE TABLE r_fund_service;
TRUNCATE TABLE r_service_portfolio;



\COPY r_fund FROM /home/sam/Data/funds/load/funds-reference-data/funds-r_fund.csv delimiter ',' csv header;
\COPY r_service FROM /home/sam/Data/funds/load/funds-reference-data/funds-r_service.csv delimiter ',' csv header;
\COPY r_portfolio FROM /home/sam/Data/funds/load/funds-reference-data/funds-r_portfolio.csv delimiter ',' csv header;
\COPY r_fund_service FROM /home/sam/Data/funds/load/funds-reference-data/funds-r_fund_service.csv delimiter ',' csv header;
\COPY r_service_portfolio FROM /home/sam/Data/funds/load/funds-reference-data/funds-r_service_portfolio.csv delimiter ',' csv header;
