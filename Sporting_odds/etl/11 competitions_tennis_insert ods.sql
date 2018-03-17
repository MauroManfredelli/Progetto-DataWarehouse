use sa;

create table matches_atpmt_ (
	id varchar(45),
    ATP varchar(45),
    Location varchar(100),
    Tournament varchar(100),
    Date varchar(45),
    season varchar(45),
    portion varchar(45),
    Winner varchar(45),
    Loser varchar(45),
    WSets varchar(45),
    LSets varchar(45),
    B365W varchar(45),
    B365L varchar(45),
    LBW varchar(45),
	PSW varchar(45),
    PSL varchar(45),
    LBL varchar(45),
    SJW varchar(45),
    SJL varchar(45)
);

SET SESSION sql_mode = '';

LOAD DATA INFILE 'Sporting_odds/etl/csv/matches_atpmt_cleaned.csv'
INTO TABLE sa.matches_atpmt_ FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table matches_atpmt AS (
	SELECT c.code as country, m.*
    FROM matches_atpmt_ as m JOIN cities as c ON m.Location = c.name
);

drop table matches_atpmt_;

create table competitions_atpmt AS (
	SELECT DISTINCT country
    FROM matches_atpmt
);

create table matches_td_ (
	id varchar(45),
    ATP varchar(45),
    Location varchar(100),
    Tournament varchar(100),
    Date varchar(45),
    season varchar(45),
    portion varchar(45),
    Winner varchar(45),
    Loser varchar(45),
    WSets varchar(45),
    LSets varchar(45),
    B365W varchar(45),
    B365L varchar(45),
    LBW varchar(45),
    LBL varchar(45),
    PSW varchar(45),
    PSL varchar(45),
    SJW varchar(45),
    SJL varchar(45)
);

LOAD DATA INFILE 'Sporting_odds/etl/csv/matches_td_cleaned.csv'
INTO TABLE sa.matches_td_ FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table matches_td AS (
	SELECT c.code as country, m.*
    FROM matches_td_ as m JOIN cities as c ON m.Location = c.name
);

drop table matches_td_;

create table competitions_td AS (
	SELECT DISTINCT country
    from matches_td
);

create table competitions_tennis as (
	select a.country
    from competitions_atpmt as a join competitions_td as t on a.country=t.country
);

create table competitions_tennis_to_insert as (
	select cou.id, cou.code_2, cou.code_3
    from competitions_tennis as comp join ods.countries as cou on comp.country = cou.code_3
		left join competitions_tennis_lookup as l on cou.code_3 = l.country
	where l.id_ods is null
);

drop table competitions_tennis;

insert into ods.competitions (name, sport, country)
select concat(code_2,' Open'), 'tennis', id
from competitions_tennis_to_insert;

insert into competitions_tennis_lookup
select comp.id, tennis.code_3
from competitions_tennis_to_insert as tennis join ods.competitions as comp on concat(tennis.code_2,' Open') = comp.name;

drop table competitions_tennis_to_insert;

create table competitions_only_td as (
	select td.country
	from competitions_td as td left join competitions_atpmt as atpmt on td.country = atpmt.country
    where atpmt.country is null
);

create table competitions_only_td_to_insert as (
	select cou.id, cou.code_2, cou.code_3
    from competitions_only_td as comp join ods.countries as cou on comp.country = cou.code_3
		left join competitions_tennis_lookup as l on cou.code_3 = l.country
	where l.id_ods is null
);

/*drop table competitions_only_td;*/

insert into ods.competitions (name, sport, country)
select concat(code_2,' Open'), 'tennis', id
from competitions_only_td_to_insert;

insert into competitions_tennis_lookup
select comp.id, tennis.code_3
from competitions_only_td_to_insert as tennis join ods.competitions as comp on concat(tennis.code_2,' Open') = comp.name;

drop table competitions_only_td_to_insert;

create table competitions_only_atpmt as (
	select atpmt.country
	from competitions_atpmt as atpmt left join competitions_td as td on atpmt.country = td.country
    where td.country is null
);

drop table competitions_td;
drop table competitions_atpmt;

create table competitions_only_atpmt_to_insert as (
	select cou.id, cou.code_2, cou.code_3
    from competitions_only_atpmt as comp join ods.countries as cou on comp.country = cou.code_3
		left join competitions_tennis_lookup as l on cou.code_3 = l.country
	where l.id_ods is null
);

drop table competitions_only_atpmt;

insert into ods.competitions (name, sport, country)
select concat(code_2,' Open'), 'tennis', id
from competitions_only_atpmt_to_insert;

insert into competitions_tennis_lookup
select comp.id, atpmt.code_3
from competitions_only_atpmt_to_insert as atpmt join ods.competitions as comp on concat(atpmt.code_2,' Open') = comp.name;

drop table competitions_only_atpmt_to_insert;
