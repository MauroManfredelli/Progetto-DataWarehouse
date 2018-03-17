drop schema if exists european_soccer;
create schema european_soccer;
use european_soccer;

CREATE TABLE countries (
	id	VARCHAR(45) PRIMARY KEY,
	name	VARCHAR(100)
);

CREATE TABLE leagues (
	id	VARCHAR(45) PRIMARY KEY,
	country_id	VARCHAR(45),
	name VARCHAR(100),
	FOREIGN KEY(country_id) REFERENCES countries(id)
);

CREATE TABLE teams (
	id	VARCHAR(45) PRIMARY KEY,
	team_api_id	VARCHAR(45) UNIQUE, 
	team_fifa_api_id	VARCHAR(45),
	team_long_name	VARCHAR(45),
	team_short_name	VARCHAR(45)
);

CREATE TABLE matches (
	id	VARCHAR(45) PRIMARY KEY,
	country_id	VARCHAR(45),
	league_id	VARCHAR(45),
	season	VARCHAR(45),
	portion	VARCHAR(45),
	date	VARCHAR(45),
	match_api_id	VARCHAR(45),
	home_team_api_id	VARCHAR(45),
	away_team_api_id	VARCHAR(45),
	home_team_goal	VARCHAR(45),
	away_team_goal	VARCHAR(45),
	B365H	VARCHAR(45),
	B365D	VARCHAR(45),
	B365A	VARCHAR(45),
	LBH	VARCHAR(45),
	LBD	VARCHAR(45),
	LBA	VARCHAR(45),
	PSH	VARCHAR(45),
	PSD	VARCHAR(45),
	PSA	VARCHAR(45),
	SJH	VARCHAR(45),
	SJD	VARCHAR(45),
	SJA	VARCHAR(45),
	FOREIGN KEY(home_team_api_id) REFERENCES teams(team_api_id),
	FOREIGN KEY(league_id) REFERENCES leagues(id),
	FOREIGN KEY(country_id) REFERENCES countries(id),
	FOREIGN KEY(away_team_api_id) REFERENCES teams(team_api_id)
);