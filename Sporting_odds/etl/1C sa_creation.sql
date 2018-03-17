drop schema if exists sa;
create schema sa;
use sa;

CREATE TABLE sa.countries_football_lookup (
	id_ods int,
    id_esdb varchar(45),
    div_id_fd varchar (45)
);

CREATE TABLE sa.competitions_football_lookup (
	id_ods int,
    id_esdb varchar(45),
    id_fd varchar(45)
);

CREATE TABLE sa.participants_football_lookup (
	id_ods int,
    id_esdb varchar(45),
    name_fd varchar(100)
);

CREATE TABLE competitions_tennis_lookup (
	id_ods int,
    country varchar(3)
);

ALTER TABLE `sa`.`participants_football_lookup` 
ADD INDEX `fd` (`name_fd` ASC),
ADD INDEX `esdb` (`id_esdb` ASC);

ALTER TABLE `sa`.`competitions_tennis_lookup` 
ADD INDEX `country` (`country` ASC);

ALTER TABLE `sa`.`competitions_football_lookup` 
ADD INDEX `fd` (`id_fd` ASC),
ADD INDEX `esdb` (`id_esdb` ASC);
