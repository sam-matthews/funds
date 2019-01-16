#!/bin/bash

# install-reference.sh
# Created: 16th January 2019
# Author: Sam Matthews

# Parameters

LOAD_HOME="${HOME}/Data/funds/load"
REFR_HOME=${LOAD_HOME}/funds-reference-data

# Truncate Load  reference data

psql << EOF

TRUNCATE TABLE r_fund;
TRUNCATE TABLE r_service;
TRUNCATE TABLE r_portfolio;
TRUNCATE TABLE r_fund_service;
TRUNCATE TABLE r_service_portfolio;

\COPY r_fund 			FROM ${REFR_HOME}/funds-r_fund.csv 		DELIMITER ',' CSV HEADER;
\COPY r_service 		FROM ${REFR_HOME}/funds-r_service.csv 		DELIMITER ',' CSV HEADER;
\COPY r_portfolio 		FROM ${REFR_HOME}/funds-r_portfolio.csv 	DELIMITER ',' CSV HEADER;
\COPY r_fund_service 		FROM ${REFR_HOME}/funds-r_fund_service.csv 	DELIMITER ',' CSV HEADER;
\COPY r_service_portfolio	FROM ${REFR_HOME}/funds-r_service_portfolio.csv	DELIMITER ',' CSV HEADER;


EOF

