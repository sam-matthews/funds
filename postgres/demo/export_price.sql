COPY (SELECT * FROM price)
TO '/home/sam/Security/data/unload/FULL-PRICE.csv' DELIMITER ',' CSV HEADER;
