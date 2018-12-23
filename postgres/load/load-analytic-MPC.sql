/*

load-analtic-MPC.sql
Sam Matthews
22nd October 2018

Script to load some sample data into analytic_lkp.sql

*/

DELETE FROM analytic_lkp WHERE a_fund = 'MPC';

INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
VALUES('MPC','SMA','6');

INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
VALUES('MPC','SMA','12');

INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
VALUES('MPC','SMA','25');

INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
VALUES('MPC','SMA','50');

INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
VALUES('MPC','SMA','100');

INSERT INTO analytic_lkp(a_fund, a_type, a_level1)
VALUES('MPC','SMA','200');

COMMIT;
