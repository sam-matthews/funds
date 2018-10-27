-- month.sql
-- Run to re-generate month end data.

SELECT FROM EOM_Generation();
SELECT FROM calcEOMMovement();
SELECT FROM EomSMA();

-- Verification
SELECT * FROM eom_generation
WHERE e_fund = 'MPD'
ORDER BY e_date LIMIT 10
;


