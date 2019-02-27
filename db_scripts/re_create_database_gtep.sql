-- MySQL Script generated by MySQL Workbench
-- Sun Feb 24 10:35:51 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema gtep
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `gtep` ;

-- -----------------------------------------------------
-- Schema gtep
-- -----------------------------------------------------
CREATE DATABASE `gtep` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `gtep` ;

-- -----------------------------------------------------
-- Table `candidate`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `candidate` ;

CREATE TABLE `candidate` (
  `cid` INT(4) NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `delegate_count` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`cid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `state` ;

CREATE TABLE `state` (
  `state_code` VARCHAR(2) NOT NULL COMMENT 'Two-letter unique state code',
  `name` VARCHAR(255) NOT NULL,
  `type_of_primary` VARCHAR(45) NULL DEFAULT NULL,
  `delegates_at_play` INT(11) NULL DEFAULT NULL,
  `population` INT(8) NULL DEFAULT NULL,
  `current_winner` INT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`state_code`),
  CONSTRAINT `current_winner`
    FOREIGN KEY (`current_winner`)
    REFERENCES `candidate` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;

CREATE INDEX `current_winner_idx` ON `state` (`current_winner` ASC) ;


-- -----------------------------------------------------
-- Table `query`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `query` ;

CREATE TABLE `query` (
  `qid` INT NOT NULL,
  `phrase` VARCHAR(255) NOT NULL,
  `cid` INT(4) NOT NULL COMMENT 'contains candidate_id which selected to be winner of the search phrase',
  `state_code` VARCHAR(2) NOT NULL COMMENT 'contains the two-letter state code',
  `amount` INT(7) NOT NULL,
  `qdate` DATETIME NOT NULL,
  PRIMARY KEY (`qid`),
  CONSTRAINT `candidate_winner`
    FOREIGN KEY (`cid`)
    REFERENCES `candidate` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `state_code`
    FOREIGN KEY (`state_code`)
    REFERENCES `state` (`state_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;

CREATE INDEX `query_location_idx` ON `query` (`state_code` ASC) ;

CREATE INDEX `contains_candidate_idx` ON `query` (`cid` ASC) ;


-- -----------------------------------------------------
-- Table `summary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `summary` ;

CREATE TABLE `summary` (
  `sid` INT NOT NULL,
  `cid` INT(4) NOT NULL COMMENT 'candidate id',
  `state_code` VARCHAR(2) NOT NULL COMMENT 'contains two-letter state code',
  `sdate` DATETIME NULL DEFAULT NULL,
  `delegates_won` INT(11) NULL DEFAULT 0,
  PRIMARY KEY (`sid`),
  CONSTRAINT `candidate_runs`
    FOREIGN KEY (`cid`)
    REFERENCES `candidate` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `state_win_amount`
    FOREIGN KEY (`state_code`)
    REFERENCES `state` (`state_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
ROW_FORMAT = DYNAMIC;

CREATE INDEX `candidate_runs_idx` ON `summary` (`cid` ASC) ;

CREATE INDEX `state_wins_amount_idx` ON `summary` (`state_code` ASC) ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
