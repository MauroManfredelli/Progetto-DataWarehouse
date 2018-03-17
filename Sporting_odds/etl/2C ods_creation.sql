-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ods
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ods
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ods` DEFAULT CHARACTER SET utf8 ;
USE `ods` ;

-- -----------------------------------------------------
-- Table `ods`.`countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ods`.`countries` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `code_2` VARCHAR(45) NULL DEFAULT NULL,
  `code_3` VARCHAR(3) NULL DEFAULT NULL,
  `continent` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idCountry_UNIQUE` (`id` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 2800
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ods`.`competitions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ods`.`competitions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `sport` VARCHAR(45) NOT NULL,
  `country` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idCompetion_UNIQUE` (`id` ASC),
  INDEX `fk_Competitions_Countries1_idx` (`country` ASC),
  CONSTRAINT `fk_Competitions_Countries1`
    FOREIGN KEY (`country`)
    REFERENCES `ods`.`countries` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3332
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ods`.`participants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ods`.`participants` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `country` INT(11) NULL DEFAULT NULL,
  `sport` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idPartecipant_UNIQUE` (`id` ASC),
  INDEX `fk_Partecipants_Cuntries_1_idx` (`country` ASC),
  CONSTRAINT `fk_Partecipants_Cuntries_1`
    FOREIGN KEY (`country`)
    REFERENCES `ods`.`countries` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 158465
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ods`.`matches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ods`.`matches` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `sport` VARCHAR(45) NULL DEFAULT NULL,
  `competition` INT(11) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  `season` VARCHAR(45) NULL DEFAULT NULL,
  `portion` VARCHAR(45) NULL DEFAULT NULL,
  `home_participant` INT(11) NULL DEFAULT NULL,
  `home_points` VARCHAR(45) NULL DEFAULT NULL,
  `away_participant` INT(11) NULL DEFAULT NULL,
  `away_points` VARCHAR(45) NULL DEFAULT NULL,
  `B365H` VARCHAR(45) NULL DEFAULT NULL,
  `B365D` VARCHAR(45) NULL DEFAULT NULL,
  `B365A` VARCHAR(45) NULL DEFAULT NULL,
  `LBH` VARCHAR(45) NULL DEFAULT NULL,
  `LBD` VARCHAR(45) NULL DEFAULT NULL,
  `LBA` VARCHAR(45) NULL DEFAULT NULL,
  `PSH` VARCHAR(45) NULL DEFAULT NULL,
  `PSD` VARCHAR(45) NULL DEFAULT NULL,
  `PSA` VARCHAR(45) NULL DEFAULT NULL,
  `SJH` VARCHAR(45) NULL DEFAULT NULL,
  `SJD` VARCHAR(45) NULL DEFAULT NULL,
  `SJA` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idMatch_UNIQUE` (`id` ASC),
  INDEX `fk_Matches_Partecipants1_idx` (`home_participant` ASC),
  INDEX `fk_Matches_Partecipants2_idx` (`away_participant` ASC),
  INDEX `fk_Matches_Competitions1_idx` (`competition` ASC),
  CONSTRAINT `fk_Matches_Competitions1`
    FOREIGN KEY (`competition`)
    REFERENCES `ods`.`competitions` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Matches_Partecipants1`
    FOREIGN KEY (`home_participant`)
    REFERENCES `ods`.`participants` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Matches_Partecipants2`
    FOREIGN KEY (`away_participant`)
    REFERENCES `ods`.`participants` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5296199
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
