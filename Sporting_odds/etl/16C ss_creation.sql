-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ss
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ss
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ss` DEFAULT CHARACTER SET utf8 ;
USE `ss` ;

-- -----------------------------------------------------
-- Table `ss`.`countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ss`.`countries` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_ods` INT NOT NULL,
  `name` VARCHAR(100) NULL,
  `code_2` VARCHAR(45) NULL,
  `code_3` VARCHAR(45) NULL,
  `continent` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `id_ods_UNIQUE` (`id_ods` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ss`.`dates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ss`.`dates` (
  `date` DATE NOT NULL,
  `month` INT NULL,
  `year` INT NULL,
  PRIMARY KEY (`date`),
  UNIQUE INDEX `date_UNIQUE` (`date` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ss`.`matches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ss`.`matches` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `match` INT NULL,
  `match_name` VARCHAR(100) NULL,
  `portion` INT NULL,
  `season` VARCHAR(45) NULL,
  `competition` INT NULL,
  `competition_name` VARCHAR(100) NULL,
  `sport` VARCHAR(45) NULL,
  `date` DATE NOT NULL,
  `country` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_competition_country1_idx` (`country` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_matches_dates1_idx` (`date` ASC),
  CONSTRAINT `fk_competition_country1`
    FOREIGN KEY (`country`)
    REFERENCES `ss`.`countries` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_matches_dates1`
    FOREIGN KEY (`date`)
    REFERENCES `ss`.`dates` (`date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ss`.`participants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ss`.`participants` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_ods` INT NOT NULL,
  `name` VARCHAR(100) NULL,
  `country` INT NULL,
  `sport` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_participant_country1_idx` (`country` ASC),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `id_ods_UNIQUE` (`id_ods` ASC),
  CONSTRAINT `fk_participant_country1`
    FOREIGN KEY (`country`)
    REFERENCES `ss`.`countries` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ss`.`matches_odds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ss`.`matches_odds` (
  `odd_1` DECIMAL(5,2) NULL,
  `odd_x` DECIMAL(5,2) NULL,
  `odd_2` DECIMAL(5,2) NULL,
  `bookmaker` VARCHAR(45) NOT NULL,
  `result` VARCHAR(1) NOT NULL,
  `ko` INT NOT NULL,
  `correct_odd` INT(1) NOT NULL,
  `match` INT NOT NULL,
  `home_participant` INT NOT NULL,
  `away_participant` INT NOT NULL,
  PRIMARY KEY (`bookmaker`, `result`, `ko`, `correct_odd`, `match`, `home_participant`, `away_participant`),
  INDEX `fk_match_odd_competition1_idx` (`match` ASC),
  INDEX `fk_match_odd_participant1_idx` (`home_participant` ASC),
  INDEX `fk_match_odd_participant2_idx` (`away_participant` ASC),
  CONSTRAINT `fk_match_odd_competition`
    FOREIGN KEY (`match`)
    REFERENCES `ss`.`matches` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_match_odd_participant1`
    FOREIGN KEY (`home_participant`)
    REFERENCES `ss`.`participants` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_match_odd_participant2`
    FOREIGN KEY (`away_participant`)
    REFERENCES `ss`.`participants` (`id`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

drop schema if exists sa_ss;
create schema sa_ss;