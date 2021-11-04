#!/bin/bash

# Run Reports for various portfolios.

WRAP="$HOME/Code/funds/postgres/sql/wrap.sh"
echo ${WRAP}

echo "Portfolio: HARRY"
echo "Service: SHARESIES-NZX"

${WRAP} HARRY SHARESIES-NZX

echo "Portfolio: KIWISAVER_SAM"
echo "Service: SUPERLIFE_KIWISAVER"

${WRAP} KIWISAVER_SAM SUPERLIFE_KIWISAVER
