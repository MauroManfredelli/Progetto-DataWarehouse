use european_soccer;

create table sa.participants_esdb as(
	SELECT *
	FROM (
				SELECT distinct teams.team_api_id as team_api_id, teams.team_long_name as name, matches.country_id as country_id
				FROM teams JOIN matches ON teams.team_api_id = home_team_api_id
					JOIN teams as t2 ON away_team_api_id = t2.team_api_id 
	) AS T
);

set charset 'utf8';
SET NAMES 'utf8';

SET SESSION sql_mode = '';

SELECT  *
FROM 
	((SELECT 'teamp_api_id', 'name', 'country_id')
	UNION
	(SELECT * 
	FROM sa.participants_esdb)) AS T
INTO OUTFILE 'Sporting_odds/etl/csv/created/participants_esdb.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

drop table sa.participants_esdb;