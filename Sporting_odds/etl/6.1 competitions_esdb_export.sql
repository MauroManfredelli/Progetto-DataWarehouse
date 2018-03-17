use european_soccer;

create table sa.competitions_esdb as (
	SELECT l.id as competition_id, l.name as competion_name, c.name as country_name, c.id as country_id
	FROM countries as c JOIN leagues as l ON c.id=l.country_id
);

set charset 'utf8';
SET NAMES 'utf8';

SET SESSION sql_mode = '';

SELECT  *
FROM
	((SELECT 'competiton_id', 'competition_name', 'country_name', 'country_id', 'sport')
    UNION
    (SELECT *, 'football'
	FROM sa.competitions_esdb)) AS T
INTO OUTFILE 'Sporting_odds/etl/csv/created/competitions_esdb.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

drop table sa.competitions_esdb;