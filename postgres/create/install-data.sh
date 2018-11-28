#!/bin/bash

psql -d ${DBNAME} -f ${HOME}/Code/funds/postgres/tab/price_new.tab

