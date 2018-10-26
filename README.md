# funds
Postgres and Bash Application to manage funds, prices, portfolios and analysis.

# Daily loads

The following steps should be run each day.

1. Update numbers spreadsheet and export CSV file.
2. Run the following postgres scripts.

`
load-postgres.sql
psql
> SELECT FROM sma();
`
# Loading End of Month summarised Data.

## Install

The following steps will create the required tables and functions. It's pretty straight forward, although I will generate just one script at some stage, so everything becomes simplified.

`
unix> cd $HOME/Code/funds/postgres
unix> psql -f tab/EOM_Generation.tab
unix> psql -f fun/EOM_Generate.fun
unix> psql -f fun/EOM-movement-calculation.fun
unix> psql -f fun/EOM-SMA.fun
`


## Run

`
psql
> SELECT FROM EOM_Generatation();
> SELECT FROM calcEOMMovement();
> SELECT FROM EomSMA();
`

## Verification

Run the following to verify data has been populated correctly.

`SELECT * FROM EOM_GENERATION ORDER BY 2,1`

> Output should look something like the following.

  e_date   |   e_fund   | e_price  |    e_diff    |    e_sma
------------+------------+----------+--------------+--------------
 2017-07-01 | AIF_CI     |   1.3567 |              |
 2017-08-01 | AIF_CI     |   1.3451 |  -0.00855008 |
 2017-09-01 | AIF_CI     |   1.4054 |    0.0448294 |    0.0181396
 2017-10-01 | AIF_CI     |   1.4146 |   0.00654616 |    0.0142752
 2017-11-01 | AIF_CI     |    1.523 |    0.0766294 |    0.0298637
 2017-12-01 | AIF_CI     |   1.5555 |    0.0213395 |    0.0281589
 2018-01-01 | AIF_CI     |  1.53508 |   -0.0131277 |    0.0212778
 2018-02-01 | AIF_CI     |   1.5399 |   0.00313989 |    0.0186867
 2018-03-01 | AIF_CI     |   1.5168 |   -0.0150009 |    0.0144757
 2018-04-01 | AIF_CI     |   1.4607 |   -0.0369858 |   0.00875777
 2018-05-01 | AIF_CI     |   1.5206 |    0.0410077 |    0.0119828
 2018-06-01 | AIF_CI     |   1.5233 |   0.00177567 |    0.0110548




