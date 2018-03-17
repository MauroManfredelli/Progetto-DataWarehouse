SET foreign_key_checks = 0;
use european_soccer;

SET SESSION sql_mode = '';

LOAD DATA INFILE 'Sporting_odds/etl/csv/teams_esdb_cleaned.csv'
INTO TABLE european_soccer.teams FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'Sporting_odds/etl/csv/matches_esbd_cleaned.csv'
INTO TABLE european_soccer.matches FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n';

LOAD DATA INFILE 'Sporting_odds/etl/csv/leagues_esdb_cleaned.csv'
INTO TABLE european_soccer.leagues FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n';

LOAD DATA INFILE 'Sporting_odds/etl/csv/countries_esdb_cleaned.csv'
INTO TABLE european_soccer.countries FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n';

SELECT @scotland := id from countries where name = 'Scotland';
SELECT @england := id from countries where name = 'England';

update matches
set country_id = @england
where country_id = @scotland;

update leagues
set country_id = @england
where country_id = @scotland;

update countries
set name = 'United Kingdom of Great Britain and Northern Ireland'
where id = @england;

delete from countries
where id = @scotland;

create table sa.t (
	right_id varchar(45),
    wrong_id varchar(45)
);

LOAD DATA INFILE 'Sporting_odds/etl/csv/teams_esdb_double.csv'
INTO TABLE sa.t FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

update matches, sa.t
SET home_team_api_id=right_id
WHERE home_team_api_id=wrong_id;

update matches, sa.t
SET away_team_api_id=right_id
WHERE away_team_api_id=wrong_id;

drop table sa.t;


SET foreign_key_checks = 1;