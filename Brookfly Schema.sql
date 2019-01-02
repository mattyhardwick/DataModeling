-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema maha4930school
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `maha4930school` ;

-- -----------------------------------------------------
-- Schema maha4930school
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `maha4930school` DEFAULT CHARACTER SET utf8 ;
USE `maha4930school` ;

-- -----------------------------------------------------
-- Table `parent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parent` ;

CREATE TABLE IF NOT EXISTS `parent` (
  `parentID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NULL,
  `lastName` VARCHAR(45) NULL,
  `address` VARCHAR(45) NULL,
  `phone` BIGINT(10) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`parentID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `student` ;

CREATE TABLE IF NOT EXISTS `student` (
  `studentID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NULL,
  `lastName` VARCHAR(45) NULL,
  `gender` VARCHAR(10) NULL,
  `dob` DATE NULL,
  `emergencyContact` VARCHAR(45) NULL,
  `immunizationDate` DATE NULL,
  `password` VARCHAR(45) NULL,
  `registrationDate` DATE NULL,
  `registrationTime` TIME NULL,
  `parentID` INT NOT NULL,
  PRIMARY KEY (`studentID`),
  INDEX `fk_student_parent1_idx` (`parentID` ASC) VISIBLE,
  CONSTRAINT `fk_student_parent1`
    FOREIGN KEY (`parentID`)
    REFERENCES `parent` (`parentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `staff` ;

CREATE TABLE IF NOT EXISTS `staff` (
  `staffID` INT NOT NULL AUTO_INCREMENT,
  `position` VARCHAR(45) NULL,
  `firstName` VARCHAR(45) NULL,
  `lastName` VARCHAR(45) NULL,
  `gender` VARCHAR(10) NULL,
  `dob` DATE NULL,
  `address` VARCHAR(45) NULL,
  `phone` BIGINT(10) NULL,
  `password` VARCHAR(45) NULL,
  `salary` INT NULL,
  `hireDate` DATE NULL,
  PRIMARY KEY (`staffID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `class` ;

CREATE TABLE IF NOT EXISTS `class` (
  `classNo` INT NOT NULL AUTO_INCREMENT,
  `staffID` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `startTime` TIME NULL,
  `endTime` TIME NULL,
  PRIMARY KEY (`classNo`),
  INDEX `fk_class_staff_idx` (`staffID` ASC) VISIBLE,
  CONSTRAINT `fk_class_staff`
    FOREIGN KEY (`staffID`)
    REFERENCES `staff` (`staffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assignment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assignment` ;

CREATE TABLE IF NOT EXISTS `assignment` (
  `assignmentID` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `description` VARCHAR(100) NULL,
  `dueDate` DATE NULL,
  `maxScore` INT NULL,
  `classNo` INT NOT NULL,
  PRIMARY KEY (`assignmentID`),
  INDEX `fk_assignment_class1_idx` (`classNo` ASC) VISIBLE,
  CONSTRAINT `fk_assignment_class1`
    FOREIGN KEY (`classNo`)
    REFERENCES `class` (`classNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `grade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `grade` ;

CREATE TABLE IF NOT EXISTS `grade` (
  `gradeID` INT NOT NULL AUTO_INCREMENT,
  `assignmentID` INT NOT NULL,
  `studentID` INT NOT NULL,
  `score` INT NULL,
  `maxScore` INT NULL,
  INDEX `fk_assignment_has_student_student1_idx` (`studentID` ASC) VISIBLE,
  INDEX `fk_assignment_has_student_assignment1_idx` (`assignmentID` ASC) VISIBLE,
  PRIMARY KEY (`gradeID`),
  CONSTRAINT `fk_assignment_has_student_assignment1`
    FOREIGN KEY (`assignmentID`)
    REFERENCES `assignment` (`assignmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assignment_has_student_student1`
    FOREIGN KEY (`studentID`)
    REFERENCES `student` (`studentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `billing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `billing` ;

CREATE TABLE IF NOT EXISTS `billing` (
  `billNo` INT NOT NULL AUTO_INCREMENT,
  `billingInfo` VARCHAR(45) NULL,
  `notifyDate` DATE NULL,
  `dueDate` DATE NULL,
  `parentID` INT NOT NULL,
  PRIMARY KEY (`billNo`, `parentID`),
  INDEX `fk_billing_parent1_idx` (`parentID` ASC) VISIBLE,
  CONSTRAINT `fk_billing_parent1`
    FOREIGN KEY (`parentID`)
    REFERENCES `parent` (`parentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `report`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `report` ;

CREATE TABLE IF NOT EXISTS `report` (
  `reportID` INT NOT NULL AUTO_INCREMENT,
  `classNo` INT NOT NULL,
  `studentID` INT NOT NULL,
  `percentage` INT NULL,
  INDEX `fk_class_has_student_student1_idx` (`studentID` ASC) VISIBLE,
  INDEX `fk_class_has_student_class1_idx` (`classNo` ASC) VISIBLE,
  PRIMARY KEY (`reportID`),
  CONSTRAINT `fk_class_has_student_class1`
    FOREIGN KEY (`classNo`)
    REFERENCES `class` (`classNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_class_has_student_student1`
    FOREIGN KEY (`studentID`)
    REFERENCES `student` (`studentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calendar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `calendar` ;

CREATE TABLE IF NOT EXISTS `calendar` (
  `eventNo` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NULL,
  `startDate` DATE NULL,
  `endDate` DATE NULL,
  `startTime` TIME NULL,
  `endTime` TIME NULL,
  `staffID` INT NOT NULL,
  `parentID` INT NOT NULL,
  PRIMARY KEY (`eventNo`),
  INDEX `fk_calendar_staff1_idx` (`staffID` ASC) VISIBLE,
  INDEX `fk_calendar_parent1_idx` (`parentID` ASC) VISIBLE,
  CONSTRAINT `fk_calendar_staff1`
    FOREIGN KEY (`staffID`)
    REFERENCES `staff` (`staffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_calendar_parent1`
    FOREIGN KEY (`parentID`)
    REFERENCES `parent` (`parentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
