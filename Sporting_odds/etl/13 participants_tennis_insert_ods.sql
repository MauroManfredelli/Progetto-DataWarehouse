use sa;

create table participants_tennis_ (
	name varchar (45),
    nationality varchar (45)
);

SET SESSION sql_mode = '';

LOAD DATA INFILE 'Sporting_odds/etl/csv/participants_tennis.csv'
INTO TABLE sa.participants_tennis_ FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table participants_tennis as (
	select distinct name, nationality
    from participants_tennis_
);

create table temp as (
	SELECT p1.*
	FROM sa.participants_tennis as p1 LEFT OUTER JOIN ods.participants as p2 ON p1.name=p2.name
    WHERE p2.name is null
);

create table temp2 as (
	select t.name, c.id as country
    from temp as t LEFT JOIN ods.countries as c on t.nationality = c.code_3
);

SELECT @none_id := id FROM ods.countries WHERE name='_None';

update temp2 
set country = @none_id
where country is null; 

insert into ods.participants (name, country, sport) select name, country, 'tennis' from temp2;

drop table participants_tennis_;
drop table participants_tennis;
drop table temp;
drop table temp2;