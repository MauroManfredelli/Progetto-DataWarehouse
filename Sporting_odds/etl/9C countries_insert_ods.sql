use sa;

SET foreign_key_checks = 0;

CREATE TABLE temp (
	name varchar(150),
    code_2 varchar(45),
    code_3 varchar(45),
    continent varchar(45)
);

LOAD DATA INFILE 'Sporting_odds/etl/csv/countries_cleaned.csv'
INTO TABLE temp
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

INSERT INTO ods.countries (name, code_2, code_3, continent)
SELECT *
FROM temp;

DROP TABLE temp;

SET foreign_key_checks = 1;