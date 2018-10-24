# funds
Postgres and Bash Application to manage funds, prices, portfolios and analysis.

# Loading End of Month summarised Data.

## Create steps

1. Create table @tab/EOM_Generation.tab
2. Generate EOM Price Data into EOM_Generatation table @fun/EOM_Generate.fun
3. Generate price movement @fun/EOM-movement-calculation.fun

## Assume psql -f <script> has been run.

## Run

```
psql
> SELECT FROM EOM_Generatation();
> SELECT FROM calcEOMMovement();
```

## Verifaction

Run the following to verify data has been populated correctly.

SELECT * FROM EOM_GENERATION ORDER BY 2,1

> Output should look something like the following.

   e_date   |   e_fund   | e_price  |    e_diff
------------+------------+----------+--------------
 2017-11-01 | MKA        |   3.2848 |    0.0262435
 2017-12-01 | MKA        |   3.3154 |   0.00931558
 2018-01-01 | MKA        |   3.3882 |    0.0219582
 2018-02-01 | MKA        |   3.4152 |   0.00796882
 2018-03-01 | MKA        |   3.3898 |  -0.00743732
 2018-04-01 | MKA        |   3.4106 |   0.00613602
 2018-05-01 | MKA        |   3.4625 |    0.0152173
 2018-06-01 | MKA        |   3.5391 |    0.0221227
 2018-07-01 | MKA        |   3.5843 |    0.0127716
 2018-08-01 | MKA        |   3.6068 |   0.00627739
 2018-09-01 | MKA        |   3.6697 |    0.0174392
 2018-10-01 | MKA        |   3.6794 |   0.00264328
 2017-04-01 | MKB        |   1.9674 |   0.00763123
 2017-05-01 | MKB        |   1.9988 |    0.0159602
 2017-06-01 | MKB        |   2.0212 |    0.0112067
 2017-07-01 | MKB        |   2.0064 |   -0.0073223
 2017-08-01 | MKB        |   2.0149 |   0.00423637
 2017-09-01 | MKB        |   2.0416 |    0.0132513
 2017-10-01 | MKB        |   2.0551 |   0.00661245




