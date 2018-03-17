USE sa;

SET SESSION sql_mode = '';

CREATE TABLE divisions_fd (
	id varchar(45),
    name varchar (100),
    country varchar(100)
);

LOAD DATA INFILE 'Sporting_odds/dataset/Football-data/divisions_fd.csv'
INTO TABLE divisions_fd FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n';


CREATE TABLE competitions_fd_to_update AS (
	SELECT c.id, d.name
    FROM divisions_fd as d JOIN competitions_football_lookup as l ON d.id = l.id_fd
		JOIN ods.competitions as c ON l.id_ods = c.id
	WHERE l.id_esdb is null and d.name <> c.name
);

UPDATE ods.competitions as c, sa.competitions_fd_to_update as t
SET c.name = t.name
WHERE c.id=t.id;

drop table competitions_fd_to_update;
drop table divisions_fd;


CREATE TABLE competitions_esdb_to_update AS (
	SELECT c.id, l.name
    FROM european_soccer.leagues as l JOIN competitions_football_lookup as lo ON l.id = lo.id_esdb
		JOIN ods.competitions as c ON lo.id_esdb = c.id
	WHERE l.name <> c.name
);

UPDATE ods.competitions as c, sa.competitions_esdb_to_update as t
SET c.name = t.name
WHERE c.id=t.id;

drop table competitions_esdb_to_update;

create table sa.competitions_football (
	id_esdb varchar(45),
    id_fd varchar(45),
    name varchar(100),
    country varchar(100),
    country_id_esdb varchar (45)
);

LOAD DATA INFILE 'Sporting_odds/etl/csv/competitions_football.csv'
INTO TABLE sa.competitions_football FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

update sa.competitions_football 
set id_esdb = null
where id_esdb = '';

update sa.competitions_football
set id_fd = null
where id_fd = '';

CREATE TABLE sa.competitions_football_to_insert_ as (
	SELECT c.name, c.id_esdb, c.id_fd, c.country, c.country_id_esdb
    FROM sa.competitions_football as c LEFT JOIN sa.competitions_football_lookup as l on c.id_esdb = l.id_esdb or c.id_fd = l.id_fd
    WHERE l.id_esdb is null and l.id_fd is null
);

CREATE TABLE sa.competitions_football_to_insert as (
	SELECT t.name, t.id_esdb, t.id_fd, c.id as country, t.country_id_esdb
    FROM sa.competitions_football_to_insert_ as t join ods.countries as c ON t.country = c.name
);

INSERT INTO ods.competitions (name, sport, country) (
	SELECT c.name, 'football', c.country
    FROM sa.competitions_football_to_insert as c
);


INSERT INTO sa.competitions_football_lookup ( 
	SELECT c.id, t.id_esdb, t.id_fd
    FROM sa.competitions_football_to_insert as t JOIN ods.competitions as c ON t.name=c.name and t.country=c.country
);

INSERT INTO sa.countries_football_lookup (
	SELECT DISTINCT country, country_id_esdb, null
    FROM sa.competitions_football_to_insert 
    where not(country_id_esdb is null)
);

INSERT INTO sa.countries_football_lookup (
	SELECT country, null, id_fd
    FROM sa.competitions_football_to_insert
    where not(id_fd is null)
);

drop table sa.competitions_football_to_insert_;
drop table sa.competitions_football_to_insert;
drop table sa.competitions_football;
