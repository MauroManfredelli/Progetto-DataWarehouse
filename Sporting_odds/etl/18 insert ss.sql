use sa_ss;

SET foreign_key_checks = 0;

SELECT @max_date_ := MAX(date) FROM ss.dates;

SELECT @max_date := CASE WHEN (not(@max_date_ is null)) then @max_date_ else date_format(str_to_date('31/12/2007', '%d/%m/%Y'), '%Y%m%d') end;

create table participants_to_update (
	SELECT p1.id, p1.name
    FROM ods.participants as p1 JOIN ss.participants as p2 ON p1.id = p2.id_ods
    WHERE p1.name <> p2.name
);

UPDATE ss.participants as p, participants_to_update as u
SET p.name = u.name
WHERE p.id = u.id;

drop table participants_to_update;


create table participants_to_insert_ as (
	select p1.*
    from ods.participants as p1 left join ss.participants as p2 ON p1.id = p2.id_ods
    where isnull(p2.id)
);

create table participants_to_insert as (
	select p.id as id_ods, p.name, c.id as country, p.sport
    from participants_to_insert_ as p join ss.countries as c on p.country = c.id_ods
);

drop table participants_to_insert_;

insert into ss.participants (id_ods, name, country, sport)
select *
from sa_ss.participants_to_insert;

drop table participants_to_insert;


create table competitions_to_update as (
	select c1.id, c1.name
    from ods.competitions as c1 JOIN ss.matches as c2 ON c1.id = c2.competition
    WHERE c1.name <> c2.competition_name
);

update ss.matches as c1, competitions_to_update as c2
set c1.competition_name = c2.name
where c1.id = c2.id;

drop table competitions_to_update;

create table matches as (
	SELECT m.id as 'match', m.sport, c.id as competition, c.name as competition_name, cou.id as country, m.date, m.season, m.portion, p1.id as home_participant, p1.name as home_name, m.home_points, p2.id as away_participant, p2.name as away_name, m.away_points, m.B365H, m.B365D, m.B365A, m.LBH, m.LBD, m.LBA, m.PSH, m.PSD, m.PSA, m.SJH, m.SJD, m.SJA
    FROM ods.matches as m JOIN ss.participants as p1 ON m.home_participant=p1.id_ods
		JOIN ss.participants as p2 ON m.away_participant = p2.id_ods
        JOIN ods.competitions as c ON m.competition = c.id
        JOIN ss.countries as cou ON c.country=cou.id_ods
	WHERE m.date > @max_date
);

insert into ss.matches (ss.matches.match, match_name, portion, season, competition, competition_name, sport, country, date)
select DISTINCT 
	m.match,
    concat(m.home_name,'_',m.away_name),
    m.portion,
    m.season,
    m.competition,
    m.competition_name,
    m.sport,
    m.country,
    m.date
from matches as m;

create table matches_odd as (
	select m1.B365H, m1.B365A, m1.B365D, m1.LBH, m1.LBA, m1.LBD, m1.PSH, m1.PSA, m1.PSD, m1.SJH, m1.SJA, m1.SJD, m2.id as 'match', m1.home_participant, m1.home_points, m1.away_participant, m1.away_points, m1.sport
    from matches as m1 join ss.matches as m2 on m1.match=m2.match
);

insert into ss.dates
SELECT DISTINCT m.date, month(m.date), year(m.date)
from matches as m;

drop table matches;

SET SESSION sql_mode = '';


insert into ss.matches_odds
select 
	CONVERT(m.B365H, DECIMAL(5,2)),
	(CASE WHEN m.B365D=0 or m.B365d is null then null
		else CONVERT(m.B365D, DECIMAL(5,2))
	end),
	CONVERT(m.B365A, DECIMAL(5,2)),
    'B365',
    (CASE WHEN m.home_points>m.away_points then '1' when away_points>home_points then '2' else 'x' end),
	(CASE WHEN
		(abs(m.home_points-m.away_points)>2 and m.sport='football')
        or ((m.home_points=3 or m.home_points=5) and m.away_points=0 and m.sport='tennis')
	THEN 1 else 0 END),
	(CASE WHEN
		(not (m.B365D is null) and m.home_points>m.away_points and m.B365H<=m.B365D and m.B365H<=m.B365A)
        or (m.B365D is null and m.home_points>m.away_points and m.B365H<=m.B365A)
        or (not(m.B365D is null) and m.home_points=m.away_points and m.B365D<m.B365H and m.B365D<m.B365A)
        or (not(m.B365D is null) and m.home_points<m.away_points and m.B365A<m.B365H and m.B365A<m.B365D)
        or (m.B365D is null and m.home_points<m.away_points and m.B365A<m.B365H)
	THEN 1 else 0 end),
    m.match,
    m.home_participant,
    m.away_participant
from matches_odd as m
where not(m.B365H is null) and m.B365H>0 AND not(m.B365A is null) and m.B365A>0;

insert into ss.matches_odds
select 
	CONVERT(m.LBH, DECIMAL(5,2)),
	(CASE WHEN m.LBD=0 or m.LBd is null then null
		else CONVERT(m.LBD, DECIMAL(5,2))
	end),
	CONVERT(m.LBA, DECIMAL(5,2)),
    'LB',
    (CASE WHEN m.home_points>m.away_points then '1' when away_points>home_points then '2' else 'x' end),
	(CASE WHEN
		(abs(m.home_points-m.away_points)>2 and m.sport='football')
        or ((m.home_points=3 or m.home_points=5) and m.away_points=0 and m.sport='tennis')
	THEN 1 else 0 END),
	(CASE WHEN
		(not (m.LBD is null) and m.home_points>m.away_points and m.LBH<=m.LBD and m.LBH<=m.LBA)
        or (m.LBD is null and m.home_points>m.away_points and m.LBH<=m.LBA)
        or (not(m.LBD is null) and m.home_points=m.away_points and m.LBD<m.LBH and m.LBD<m.LBA)
        or (not(m.LBD is null) and m.home_points<m.away_points and m.LBA<m.LBH and m.LBA<m.LBD)
        or (m.LBD is null and m.home_points<m.away_points and m.LBA<m.LBH)
	THEN 1 else 0 end),
    m.match,
    m.home_participant,
    m.away_participant
from matches_odd as m
where not(m.LBH is null) and m.LBH>0 AND not(m.LBA is null) and m.LBA>0;

insert into ss.matches_odds
select 
	CONVERT(m.PSH, DECIMAL(5,2)),
	(CASE WHEN m.PSD=0 or m.PSd is null then null
		else CONVERT(m.PSD, DECIMAL(5,2))
	end),
	CONVERT(m.PSA, DECIMAL(5,2)),
    'PS',
    (CASE WHEN m.home_points>m.away_points then '1' when away_points>home_points then '2' else 'x' end),
	(CASE WHEN
		(abs(m.home_points-m.away_points)>2 and m.sport='football')
        or ((m.home_points=3 or m.home_points=5) and m.away_points=0 and m.sport='tennis')
	THEN 1 else 0 END),
	(CASE WHEN
		(not (m.PSD is null) and m.home_points>m.away_points and m.PSH<=m.PSD and m.PSH<=m.PSA)
        or (m.PSD is null and m.home_points>m.away_points and m.PSH<=m.PSA)
        or (not(m.PSD is null) and m.home_points=m.away_points and m.PSD<m.PSH and m.PSD<m.PSA)
        or (not(m.PSD is null) and m.home_points<m.away_points and m.PSA<m.PSH and m.PSA<m.PSD)
        or (m.PSD is null and m.home_points<m.away_points and m.PSA<m.PSH)
	THEN 1 else 0 end),
    m.match,
    m.home_participant,
    m.away_participant
from matches_odd as m
where not(m.PSH is null) and m.PSH>0 AND not(m.PSA is null) and m.PSA>0;

insert into ss.matches_odds
select 
	CONVERT(m.SJH, DECIMAL(5,2)),
	(CASE WHEN m.SJD=0 or m.SJd is null then null
		else CONVERT(m.SJD, DECIMAL(5,2))
	end),
	CONVERT(m.SJA, DECIMAL(5,2)),
    'SJ',
    (CASE WHEN m.home_points>m.away_points then '1' when away_points>home_points then '2' else 'x' end),
	(CASE WHEN
		(abs(m.home_points-m.away_points)>2 and m.sport='football')
        or ((m.home_points=3 or m.home_points=5) and m.away_points=0 and m.sport='tennis')
	THEN 1 else 0 END),
	(CASE WHEN
		(not (m.SJD is null) and m.home_points>m.away_points and m.SJH<=m.SJD and m.SJH<=m.SJA)
        or (m.SJD is null and m.home_points>m.away_points and m.SJH<=m.SJA)
        or (not(m.SJD is null) and m.home_points=m.away_points and m.SJD<m.SJH and m.SJD<m.SJA)
        or (not(m.SJD is null) and m.home_points<m.away_points and m.SJA<m.SJH and m.SJA<m.SJD)
        or (m.SJD is null and m.home_points<m.away_points and m.SJA<m.SJH)
	THEN 1 else 0 end),
    m.match,
    m.home_participant,
    m.away_participant
from matches_odd as m
where not(m.SJH is null) and m.SJH>0 AND not(m.SJA is null) and m.SJA>0;

drop table matches_odd;

SET foreign_key_checks = 0;
