#!/bin/bash

# drop-all.sh
# Sam Matthews
# 23rd December 2018

# Remove all Postgres database objects.

psql -f $DB_HOME/sql/drop-all.sql
