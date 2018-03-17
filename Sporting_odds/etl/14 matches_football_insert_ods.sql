SET foreign_key_checks = 0;

use sa;

create table matches_fd (
	id varchar(45),
    division varchar(45),
    Date varchar(45),
    HomeTeam varchar(45),
    AwayTeam varchar(45),
    FTHG varchar(45),
    FTAG varchar(45),
    season varchar(45),
    portion varchar(45),
    B365H varchar(45),
    B365D varchar(45),
    B365A varchar(45),
    LBH varchar(45),
    LBD varchar(45),
    LBA varchar(45),
    PSH varchar(45),
    PSD varchar(45),
    PSA varchar(45),
    SJH varchar(45),
    SJD varchar(45),
    SJA varchar(45)
);

SET SESSION sql_mode = '';

LOAD DATA INFILE 'Sporting_odds/etl/csv/matches_fd_cleaned.csv'
INTO TABLE sa.matches_fd FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;


/*______________________________________________
MATCH IN COMUNE TRA I DUE DATASET
______________________________________________*/

CREATE TABLE matches_football_ as (
	SELECT fd.id as id_fd, esdb.id as id_esdb, fd.date, fd.division as competition, esdb.season, esdb.portion, ph1.id_ods as home_participant, pa1.id_ods as away_participant, fd.FTHG as home_points, fd.FTAG as away_points, fd.B365H, fd.B365D, fd.B365A, fd.LBH, fd.LBD, fd.LBA, fd.SJH, fd.SJD, fd.SJA, fd.PSH, fd.PSD, fd.PSA
	FROM sa.matches_fd as fd JOIN european_soccer.matches as esdb ON fd.date=esdb.date 
		JOIN sa.participants_football_lookup as ph1 ON fd.HomeTeam = ph1.name_fd
        JOIN sa.participants_football_lookup as pa1 ON fd.AwayTeam = pa1.name_fd
        JOIN sa.participants_football_lookup as ph2 ON esdb.home_team_api_id = ph1.id_esdb
        JOIN sa.participants_football_lookup as pa2 ON esdb.away_team_api_id = pa2.id_esdb
	WHERE ph1.id_ods=ph2.id_ods and pa1.id_ods=pa2.id_ods
);

CREATE TABLE matches_football AS (
	SELECT 'football' as sport, c.id_ods as competition, date_format(str_to_date(m.date, '%d/%m/%Y'), '%Y%m%d'), m.season, m.portion, m.home_participant, m.home_points, m.away_participant, m.away_points, m.B365H, m.B365D, m.B365A, m.LBH, m.LBD, m.LBA, m.SJH, m.SJD, m.SJA, m.PSH, m.PSD, m.PSA
    FROM matches_football_ as m JOIN competitions_football_lookup as c ON m.competition = c.id_fd
);

INSERT INTO ods.matches (sport, competition, date, season, portion, home_participant, home_points, away_participant, away_points, B365H, B365D, B365A, LBH, LBD, LBA, SJH, SJD, SJA, PSH, PSD, PSA)
SELECT *
FROM matches_football;
	
    
/*______________________________________________
MATCHES SOLO IN fd
______________________________________________*/

create table matches_only_fd_ as (
	SELECT fd.*
    FROM sa.matches_fd as fd LEFT OUTER JOIN sa.matches_football_ m ON fd.id=m.id_fd
    WHERE m.id_fd is null
);

CREATE TABLE matches_only_fd AS (
	SELECT 'football' as sport, c.id_ods as competition, date_format(str_to_date(m.date, '%d/%m/%Y'), '%Y%m%d'), m.season, m.portion, p1.id_ods as home_participant, m.FTHG as home_points, p2.id_ods as away_participant, m.FTAG as away_points, m.B365H, m.B365D, m.B365A, m.LBH, m.LBD, m.LBA, m.PSH, m.PSD, m.PSA, m.SJH, m.SJD, m.SJA
    FROM matches_only_fd_ as m JOIN competitions_football_lookup as c ON m.division = c.id_fd
		JOIN participants_football_lookup as p1 on m.HomeTeam = p1.name_fd
        JOIN participants_football_lookup as p2 on m.AwayTeam = p2.name_fd
);

INSERT INTO ods.matches (sport, competition, date, season, portion, home_participant, home_points, away_participant, away_points, B365H, B365D, B365A, LBH, LBD, LBA, PSH, PSD, PSA, SJH, SJD, SJA)
SELECT *
FROM matches_only_fd;

/*______________________________________________
MATCHES SOLO IN esdb
______________________________________________*/

create table matches_only_esdb_ as (
	SELECT esdb.*
    FROM european_soccer.matches as esdb LEFT OUTER JOIN sa.matches_football_ m ON esdb.id=m.id_esdb
    WHERE m.id_esdb is null
);

CREATE TABLE matches_only_esdb AS (
	SELECT 'football' as sport, c.id_ods as competition, date_format(str_to_date(m.date, '%d/%m/%Y'), '%Y%m%d'), m.season, m.portion, p1.id_ods as home_participant, m.home_team_goal as home_points, p2.id_ods as away_participant, m.away_team_goal as away_points, m.B365H, m.B365D, m.B365A, m.LBH, m.LBD, m.LBA, m.SJH, m.SJD, m.SJA, m.PSH, m.PSD, m.PSA
    FROM matches_only_esdb_ as m JOIN competitions_football_lookup as c ON m.league_id = c.id_esdb
		JOIN participants_football_lookup as p1 on m.home_team_api_id = p1.id_esdb
        JOIN participants_football_lookup as p2 on m.away_team_api_id = p2.id_esdb
);


INSERT INTO ods.matches (sport, competition, date, season, portion, home_participant, home_points, away_participant, away_points, B365H, B365D, B365A, LBH, LBD, LBA, SJH, SJD, SJA, PSH, PSD, PSA)
SELECT *
FROM matches_only_esdb;


SET foreign_key_checks = 1;

drop table matches_football;
drop table matches_football_;
drop table matches_fd;
drop table matches_only_fd;
drop table matches_only_esdb;
drop table matches_only_fd_;
drop table matches_only_esdb_;