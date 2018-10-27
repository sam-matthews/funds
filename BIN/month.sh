#!/bin/bash

#
#  month.sh
#  Sam Matthews
#  26th October 2018
#
#  Run month scripts (after CSV for daily data has been loaded.

#

psql -f ${HOME}/Code/funds/postgres/sql/month.sql

