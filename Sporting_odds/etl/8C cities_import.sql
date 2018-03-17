DROP TABLE IF EXISTS sa.cities;

CREATE TABLE sa.cities (
	name varchar(100),
    code varchar(45)
);

ALTER TABLE `sa`.`cities` 
ADD INDEX `name` (`name` ASC);

LOAD DATA INFILE 'Sporting_odds/etl/csv/cities_cleaned.csv'
INTO TABLE sa.cities FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;