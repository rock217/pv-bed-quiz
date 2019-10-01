-- -----------------------------------------------------
-- Schema hockey
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hockey` DEFAULT CHARACTER SET utf8 ;
USE `hockey` ;

-- -----------------------------------------------------
-- Table `hockey`.`team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hockey`.`team` (
  `team_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(125) NOT NULL,
  `city` VARCHAR(125) NOT NULL,
  `state` CHAR(2) NOT NULL,
  PRIMARY KEY (`team_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hockey`.`position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hockey`.`position` (
  `name` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;

INSERT INTO `hockey`.`position` (`name`) VALUES ('right wing'), ('left wing'), ('center'), ('defense'), ('goalie');


-- -----------------------------------------------------
-- Table `hockey`.`player`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hockey`.`player` (
  `player_id` INT UNSIGNED NOT NULL,
  `first_name` VARCHAR(75) NOT NULL,
  `last_name` VARCHAR(125) NOT NULL,
  `signed_date` DATE NOT NULL,
  `retired_date` DATE NULL,
  `FK_position` VARCHAR(16) NOT NULL,
  `FK_team_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`player_id`),
  INDEX `fk_player_team_idx` (`FK_team_id` ASC),
  INDEX `fk_player_position_idx` (`FK_position` ASC),
  CONSTRAINT `fk_player_team`
    FOREIGN KEY (`FK_team_id`)
    REFERENCES `hockey`.`team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_position`
    FOREIGN KEY (`FK_position`)
    REFERENCES `hockey`.`position` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hockey`.`goal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hockey`.`goal` (
  `goal_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FK_player_id` INT UNSIGNED NOT NULL,
  `timestamp` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`goal_id`),
  INDEX `fk_goal_player_idx` (`FK_player_id` ASC),
  CONSTRAINT `fk_goal_player`
    FOREIGN KEY (`FK_player_id`)
    REFERENCES `hockey`.`player` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
