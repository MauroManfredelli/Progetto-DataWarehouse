SET foreign_key_checks = 0;

use sa;

CREATE TABLE sa.teams_to_update AS (
	SELECT ot.id as id, t.team_long_name as name
	FROM european_soccer.teams as t JOIN sa.participants_football_lookup as l ON t.team_api_id = l.id_esdb
		JOIN ods.participants as ot ON l.id_ods=ot.id
	WHERE t.team_long_name <> ot.name
);

UPDATE ods.participants as p, sa.teams_to_update as t
SET p.name = t.name
WHERE p.id = t.id;

drop table teams_to_update;

create table sa.participants_football (
	name varchar(100),
	name_esdb varchar(100),
    name_fd varchar(100),
    id_esdb varchar(45),
    country_id varchar(45),
    dataset varchar(45)
);

SET SESSION sql_mode = '';

LOAD DATA INFILE 'Sporting_odds/etl/csv/participants_football.csv'
INTO TABLE sa.participants_football FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table sa.participants_football_to_insert_ as (
	SELECT p1.*
	FROM sa.participants_football as p1 LEFT JOIN sa.participants_football_lookup as p2 ON p1.id_esdb = p2.id_esdb or p1.name_fd = p2.name_fd
    WHERE p2.id_esdb is null or p2.name_fd is null
);

create table sa.participants_football_to_insert as (
	SELECT t.name, t.name_fd, t.id_esdb, c.id_ods as country
    FROM sa.participants_football_to_insert_ as t JOIN sa.countries_football_lookup as c on t.country_id = c.id_esdb or t.country_id = c.div_id_fd
);

insert into ods.participants (name, country, sport) select name, country, 'football' from sa.participants_football_to_insert;

insert into sa.participants_football_lookup (
	select p2.id, p1.id_esdb, p1.name_fd
    from sa.participants_football_to_insert as p1 JOIN ods.participants as p2 on p1.name=p2.name and p1.country=p2.country
);

drop table sa.participants_football;
drop table sa.participants_football_to_insert_;
drop table sa.participants_football_to_insert;

SET foreign_key_checks = 1;