use ods;

select @max_date := MAX(date) from ods.matches;

SET SESSION sql_mode = '';

SELECT CASE WHEN not(isnull(@max_date)) THEN @max_date ELSE '2007-12-31' end
INTO OUTFILE 'Sporting_odds/etl/csv/created/max_date.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 