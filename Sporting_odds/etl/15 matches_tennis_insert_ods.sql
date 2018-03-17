use sa;
/*______________________________________________
MATCH IN COMUNE TRA I DUE DATASET
______________________________________________*/

CREATE TABLE matches_tennis_ as (
	SELECT td.id as id_td, atpmt.id as id_atpmt, td.date, td.country, td.Wsets as home_points, td.Lsets as away_points, td.season, td.portion, td.B365W, td.B365L, td.LBW, td.LBL, td.PSW, td.PSL, td.SJW, td.SJL, td.Winner as home_participant, td.Loser as away_participant
	FROM sa.matches_td as td JOIN sa.matches_atpmt as atpmt
		ON td.date=atpmt.date AND td.Winner = atpmt.Winner AND td.Loser = atpmt.Loser
);

CREATE TABLE matches_tennis AS (
	SELECT 'tennis' as sport, l.id_ods as competition, date_format(str_to_date(m.date, '%d/%m/%Y'), '%Y%m%d') as date, m.season, m.portion, p1.id as home_participant, m.home_points, p2.id as away_participant, m.away_points, m.B365W, m.B365L, m.LBW , m.LBL, m.PSW, m.PSL, m.SJW, m.SJL
    FROM matches_tennis_ as m JOIN competitions_tennis_lookup as l on m.country = l.country
		JOIN ods.participants as p1 on m.home_participant = p1.name
        JOIN ods.participants as p2 on m.away_participant = p2.name
	WHERE p1.sport='tennis' and p2.sport='tennis'
);

INSERT INTO ods.matches (sport, competition, date, season, portion, home_participant, home_points, away_participant, away_points, B365H, B365A, LBH, LBA, PSH, PSA, SJH, SJA)
SELECT *
FROM matches_tennis;
	
    
/*______________________________________________
MATCHES SOLO IN TD
______________________________________________*/

create table matches_only_td_ as (
	SELECT td.*
    FROM sa.matches_td as td LEFT JOIN sa.matches_tennis_ m ON td.id=m.id_td
    WHERE m.id_td is null
);

CREATE TABLE matches_only_td AS (
	SELECT 'tennis' as sport, l.id_ods as competition, date_format(str_to_date(m.date, '%d/%m/%Y'), '%Y%m%d') as date, m.season, m.portion, p1.id as home_participant, m.Wsets, p2.id as away_participant, m.Lsets, m.B365W, m.B365L, m.LBW , m.LBL, m.PSW, m.PSL, m.SJW, m.SJL
    FROM matches_only_td_ as m JOIN competitions_tennis_lookup as l on m.country = l.country
		JOIN ods.participants as p1 on m.Winner = p1.name
        JOIN ods.participants as p2 on m.Loser = p2.name
	WHERE p1.sport='tennis' and p2.sport='tennis'
);


INSERT INTO ods.matches (sport, competition, date, season, portion, home_participant, home_points, away_participant, away_points, B365H, B365A, LBH, LBA, PSH, PSA, SJH, SJA)
SELECT *
FROM matches_only_td;

/*______________________________________________
MATCHES SOLO IN ATPMT
______________________________________________*/

create table matches_only_atpmt_ as (
	SELECT atpmt.*
    FROM sa.matches_atpmt as atpmt LEFT OUTER JOIN sa.matches_tennis_ m ON atpmt.id=m.id_atpmt
    WHERE m.id_atpmt is null
);

CREATE TABLE matches_only_atpmt AS (
	SELECT 'tennis' as sport, l.id_ods as competition, date_format(str_to_date(m.date, '%d/%m/%Y'), '%Y%m%d') as date, m.season, m.portion, p1.id as home_participant, m.Wsets, p2.id as away_participant, m.Lsets, m.B365W, m.B365L, m.LBW , m.LBL, m.PSW, m.PSL, m.SJW, m.SJL
    FROM matches_only_atpmt_ as m JOIN competitions_tennis_lookup as l on m.country = l.country
		JOIN ods.participants as p1 on m.Winner = p1.name
        JOIN ods.participants as p2 on m.Loser = p2.name
	WHERE p1.sport='tennis' and p2.sport='tennis'
);

INSERT INTO ods.matches (sport, competition, date, season, portion, home_participant, home_points, away_participant, away_points, B365H, B365A, LBH, LBA, PSH, PSA, SJH, SJA)
SELECT *
FROM matches_only_atpmt;


drop table matches_tennis;
drop table matches_tennis_;
drop table matches_td;
drop table matches_atpmt;
drop table matches_only_td;
drop table matches_only_atpmt;
drop table matches_only_td_;
drop table matches_only_atpmt_;