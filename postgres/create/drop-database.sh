#!/bin/bash

#
# drop-database.sh
# Sam Matthews
# Drop Postgres database and user, including tables.
#

DBNAME=sam

sudo -u postgres psql << EOF

  \set ON_ERROR_STOP true

  drop database ${DBNAME};
  drop user ${DBNAME};

EOF

ERR_STATUS=$?

if [[ ${ERR_STATUS} -ne 0 ]]
then
  echo "Error occurred: $0: ${ERR_STATUS}"
fi

