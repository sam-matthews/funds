#!/bin/bash

psql -f ${HOME}/Code/funds/postgres/fun/EOM_Generate.fun
psql -f ${HOME}/Code/funds/postgres/fun/EOM-movement-calculation.fun
psql -f ${HOME}/Code/funds/postgres/fun/EOM-SMA.fun

