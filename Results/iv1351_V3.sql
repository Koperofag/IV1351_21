-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema iv1351
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema iv1351
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `iv1351` DEFAULT CHARACTER SET utf8 ;
USE `iv1351` ;

-- -----------------------------------------------------
-- Table `iv1351`.`person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`person` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`person` (
  `personal_number` VARCHAR(12) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `zip_code` INT NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `mail` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`personal_number`),
  UNIQUE INDEX `personal_number_UNIQUE` (`personal_number` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`instructor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`instructor` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`instructor` (
  `instructor_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personal_number` VARCHAR(12) NOT NULL,
  `teaches_group` TINYINT NULL,
  `teaches_individual` TINYINT NULL,
  `teaches_ensamble` TINYINT NULL,
  PRIMARY KEY (`instructor_id`),
  UNIQUE INDEX `personal_number_UNIQUE` (`personal_number` ASC) VISIBLE,
  UNIQUE INDEX `instructor_id_UNIQUE` (`instructor_id` ASC) VISIBLE,
  CONSTRAINT `instructor_numb`
    FOREIGN KEY (`personal_number`)
    REFERENCES `iv1351`.`person` (`personal_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`room` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`room` (
  `room_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `size` INT NOT NULL,
  `description` VARCHAR(1000) NULL,
  PRIMARY KEY (`room_id`),
  UNIQUE INDEX `room_id_UNIQUE` (`room_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`price_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`price_list` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`price_list` (
  `type` VARCHAR(100) NOT NULL,
  `price` DOUBLE UNSIGNED NOT NULL,
  PRIMARY KEY (`type`),
  UNIQUE INDEX `type_UNIQUE` (`type` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`appointment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`appointment` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`appointment` (
  `appointment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `instrument` VARCHAR(100) NULL,
  `booking_price` VARCHAR(100) NOT NULL,
  `room_id` INT UNSIGNED NOT NULL,
  `max` INT UNSIGNED NOT NULL,
  `min` INT UNSIGNED NOT NULL,
  `students_registered` INT UNSIGNED NOT NULL,
  `start_time` TIMESTAMP NOT NULL,
  `end_time` TIMESTAMP NOT NULL,
  `genre` VARCHAR(100) NULL,
  `instructor_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`appointment_id`),
  INDEX `instructor_id_idx` (`instructor_id` ASC) VISIBLE,
  UNIQUE INDEX `appointment_id_UNIQUE` (`appointment_id` ASC) VISIBLE,
  INDEX `type_idx` (`booking_price` ASC) VISIBLE,
  INDEX `room_id_idx` (`room_id` ASC) VISIBLE,
  CONSTRAINT `teacher`
    FOREIGN KEY (`instructor_id`)
    REFERENCES `iv1351`.`instructor` (`instructor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `place`
    FOREIGN KEY (`room_id`)
    REFERENCES `iv1351`.`room` (`room_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `price_class`
    FOREIGN KEY (`booking_price`)
    REFERENCES `iv1351`.`price_list` (`type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`student` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`student` (
  `student_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personal_number` VARCHAR(12) NOT NULL,
  `current_bill` INT UNSIGNED NULL,
  `sibling_id` INT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE INDEX `personal_number_UNIQUE` (`personal_number` ASC) VISIBLE,
  UNIQUE INDEX `student_id_UNIQUE` (`student_id` ASC) VISIBLE,
  CONSTRAINT `student_pnumb`
    FOREIGN KEY (`personal_number`)
    REFERENCES `iv1351`.`person` (`personal_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`students_attending`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`students_attending` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`students_attending` (
  `student_id` INT UNSIGNED NOT NULL,
  `appointment_id` INT UNSIGNED NOT NULL,
  INDEX `appointment_id_idx` (`appointment_id` ASC) VISIBLE,
  INDEX `student_id_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `appointment_ref`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `iv1351`.`appointment` (`appointment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `student_att`
    FOREIGN KEY (`student_id`)
    REFERENCES `iv1351`.`student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`instruments_for_rent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`instruments_for_rent` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`instruments_for_rent` (
  `instrument_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `brand` VARCHAR(100) NOT NULL,
  `rental_fee` DOUBLE NOT NULL,
  `in_stock` TINYINT NOT NULL,
  `instrument_type` VARCHAR(100) NOT NULL,
  `student_id` INT UNSIGNED NULL,
  PRIMARY KEY (`instrument_id`),
  UNIQUE INDEX `instrument_id_UNIQUE` (`instrument_id` ASC) VISIBLE,
  INDEX `student_renting_current_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `student_renting_current`
    FOREIGN KEY (`student_id`)
    REFERENCES `iv1351`.`student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`instructor_instrument`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`instructor_instrument` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`instructor_instrument` (
  `instructor_id` INT UNSIGNED NOT NULL,
  `instrument` VARCHAR(100) NOT NULL,
  INDEX `instructor_id_idx` (`instructor_id` ASC) VISIBLE,
  CONSTRAINT `instructor_instrument`
    FOREIGN KEY (`instructor_id`)
    REFERENCES `iv1351`.`instructor` (`instructor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`family_tree`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`family_tree` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`family_tree` (
  `student_id` INT UNSIGNED NOT NULL,
  `parent` VARCHAR(12) NOT NULL,
  INDEX `student_id_idx` (`student_id` ASC) VISIBLE,
  INDEX `personal_number_idx` (`parent` ASC) VISIBLE,
  CONSTRAINT `child_id`
    FOREIGN KEY (`student_id`)
    REFERENCES `iv1351`.`student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `parent_numb`
    FOREIGN KEY (`parent`)
    REFERENCES `iv1351`.`person` (`personal_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iv1351`.`rentals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`rentals` ;

CREATE TABLE IF NOT EXISTS `iv1351`.`rentals` (
  `instrument_id` INT UNSIGNED NOT NULL,
  `student_id` INT UNSIGNED NOT NULL,
  `start_date` TIMESTAMP NOT NULL,
  `termination_date` TIMESTAMP NULL,
  `cost` DOUBLE NOT NULL,
  `return_date` TIMESTAMP NOT NULL,
  INDEX `student_rented_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `student_rented`
    FOREIGN KEY (`student_id`)
    REFERENCES `iv1351`.`student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `instrument_rented`
    FOREIGN KEY (`instrument_id`)
    REFERENCES `iv1351`.`instruments_for_rent` (`instrument_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `iv1351` ;

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`total_lessons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`total_lessons` (`lessons` INT, `month` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`average_lessons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`average_lessons` (`lessons` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`sql_3`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`sql_3` (`lesson_taken` INT, `instructor` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`sql_4`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`sql_4` (`appointment_id` INT, `spots_left` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`total_ensambles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`total_ensambles` (`lessons` INT, `month` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`total_individual_lessons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`total_individual_lessons` (`lessons` INT, `month` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`total_group_lessons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`total_group_lessons` (`lessons` INT, `month` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`average__group_lessons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`average__group_lessons` (`lessons` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`average_ensambles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`average_ensambles` (`lessons` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`average_individual_lessons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`average_individual_lessons` (`lessons` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`search_instrument`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`search_instrument` (`instrument_id` INT, `instrument_type` INT, `brand` INT, `rental_fee` INT, `student_id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`search_rented_instrument`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`search_rented_instrument` (`instrument_id` INT, `brand` INT, `rental_fee` INT, `in_stock` INT, `instrument_type` INT, `student_id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `iv1351`.`rent_instrument`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iv1351`.`rent_instrument` (`tidigare_hyrt` INT, `cost` INT);

-- -----------------------------------------------------
-- View `iv1351`.`total_lessons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`total_lessons`;
DROP VIEW IF EXISTS `iv1351`.`total_lessons` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `total_lessons` AS
SELECT count(*) AS lessons, month(start_time) as month
FROM appointment WHERE YeAr(start_time) = 2020

GrouP bY month(start_time)
order by month(start_time)

;

-- -----------------------------------------------------
-- View `iv1351`.`average_lessons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`average_lessons`;
DROP VIEW IF EXISTS `iv1351`.`average_lessons` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `average_lessons` AS
SELECT count(*)/12 AS lessons
FROM appointment WHERE YeAr(start_time) = 2020

;

-- -----------------------------------------------------
-- View `iv1351`.`sql_3`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`sql_3`;
DROP VIEW IF EXISTS `iv1351`.`sql_3` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `sql_3` AS
SELECT count(instructor_id) AS lesson_taken, instructor_id as instructor 
from appointment where month(start_time)=12 AND year(start_time)=2020
group by instructor_id
order by lesson_taken;

-- -----------------------------------------------------
-- View `iv1351`.`sql_4`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`sql_4`;
DROP VIEW IF EXISTS `iv1351`.`sql_4` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `sql_4` AS
select appointment_id, (max - students_registered) as spots_left
from appointment
where booking_price like "e%"

;

-- -----------------------------------------------------
-- View `iv1351`.`total_ensambles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`total_ensambles`;
DROP VIEW IF EXISTS `iv1351`.`total_ensambles` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `total_ensambles` AS
SELECT count(*) AS lessons, month(start_time) as month
FROM appointment WHERE YeAr(start_time) = 2020 and booking_price like "e%"

GrouP bY month(start_time)
order by month(start_time)

;

-- -----------------------------------------------------
-- View `iv1351`.`total_individual_lessons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`total_individual_lessons`;
DROP VIEW IF EXISTS `iv1351`.`total_individual_lessons` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `total_individual_lessons` AS
SELECT count(*) AS lessons, month(start_time) as month
FROM appointment WHERE YeAr(start_time) = 2020 and booking_price like "i%"

GrouP bY month(start_time)
order by month(start_time)

;

-- -----------------------------------------------------
-- View `iv1351`.`total_group_lessons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`total_group_lessons`;
DROP VIEW IF EXISTS `iv1351`.`total_group_lessons` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `total_group_lessons` AS
SELECT (0 + count(*)) AS lessons, month(start_time) as month
FROM appointment WHERE YeAr(start_time) = 2020 and booking_price like "g%"

GrouP bY month(start_time)
order by month(start_time)

;

-- -----------------------------------------------------
-- View `iv1351`.`average__group_lessons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`average__group_lessons`;
DROP VIEW IF EXISTS `iv1351`.`average__group_lessons` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `average__group_lessons` AS
SELECT count(*)/12 AS lessons
FROM appointment WHERE YeAr(start_time) = 2020 and booking_price like "g%"

;

-- -----------------------------------------------------
-- View `iv1351`.`average_ensambles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`average_ensambles`;
DROP VIEW IF EXISTS `iv1351`.`average_ensambles` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `average_ensambles` AS
SELECT count(*)/12 AS lessons
FROM appointment WHERE YeAr(start_time) = 2020 and booking_price like "e%"

;

-- -----------------------------------------------------
-- View `iv1351`.`average_individual_lessons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`average_individual_lessons`;
DROP VIEW IF EXISTS `iv1351`.`average_individual_lessons` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `average_individual_lessons` AS
SELECT count(*)/12 AS lessons
FROM appointment WHERE YeAr(start_time) = 2020 and booking_price like "i%"

;

-- -----------------------------------------------------
-- View `iv1351`.`search_instrument`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`search_instrument`;
DROP VIEW IF EXISTS `iv1351`.`search_instrument` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `search_instrument` AS
select instrument_id, instrument_type, brand, rental_fee, student_id 
from instruments_for_rent
where in_stock = 1 and instrument_type = "drum"
;

-- -----------------------------------------------------
-- View `iv1351`.`search_rented_instrument`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`search_rented_instrument`;
DROP VIEW IF EXISTS `iv1351`.`search_rented_instrument` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `search_rented_instrument` AS
select * -- instrument_id, instrument_type, brand, rental_fee, student_id 
from instruments_for_rent
where in_stock = 0
;

-- -----------------------------------------------------
-- View `iv1351`.`rent_instrument`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `iv1351`.`rent_instrument`;
DROP VIEW IF EXISTS `iv1351`.`rent_instrument` ;
USE `iv1351`;
CREATE  OR REPLACE VIEW `rent_instrument` AS
select count(*) as tidigare_hyrt, (select rental_fee from instruments_for_rent where instrument_id = 2) as cost
from instruments_for_rent 
where student_id = 2
;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `iv1351`.`person`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('123456789012', 'John Smith', 'The Matrix', 15400, 'Stockholm', '0704206942', 'legit@mail.com');
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('567890123456', 'Brian Man', 'The Hut', 42088, 'Jerusalem', '0704288690', 'brian@biggusdickus.me');
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('901234567890', 'Donald Trump', 'Trump Tower', 721, 'New York', '0845834923', 'big.hands@trump.com');
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('234002049356', 'John Doe', 'Rådbergsgatan 34', 23901, 'Island', '0735584239', 'John.doe@gmail.com');
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('200001011337', 'Jack Shit', 'Crapstreet 69', 1337, 'Shit Dale', '0704206968', 'jack@shit.com');
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('200101011337', 'Holy Shit', 'Crapstreet 69', 1337, 'Shit Dale', '0704206969', 'holy@shit.com');
INSERT INTO `iv1351`.`person` (`personal_number`, `full_name`, `address`, `zip_code`, `city`, `phone`, `mail`) VALUES ('200201011337', 'No shit', 'Crapstreet 69', 1337, 'Shit Dale', '0704206970', 'no@shit.com');

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`instructor`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`instructor` (`instructor_id`, `personal_number`, `teaches_group`, `teaches_individual`, `teaches_ensamble`) VALUES (2, '123456789012', 1, 0, 1);
INSERT INTO `iv1351`.`instructor` (`instructor_id`, `personal_number`, `teaches_group`, `teaches_individual`, `teaches_ensamble`) VALUES (3, '567890123456', 1, 1, 1);
INSERT INTO `iv1351`.`instructor` (`instructor_id`, `personal_number`, `teaches_group`, `teaches_individual`, `teaches_ensamble`) VALUES (5, '901234567890', 0, 0, 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`room`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`room` (`room_id`, `size`, `description`) VALUES (2, 3, 'MS');
INSERT INTO `iv1351`.`room` (`room_id`, `size`, `description`) VALUES (3, 7, 'K203');

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`price_list`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('E1', 69);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('E2', 420);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('E3', 1337);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('I1', 42);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('I2', 3);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('I3', 7);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('G1', 44);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('G2', 34);
INSERT INTO `iv1351`.`price_list` (`type`, `price`) VALUES ('G3', 1488);

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`appointment`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (2, 'Flute', 'E1', 3, 4, 2, 4, '2020-04-05 22:10:10', '2020-05-07 22:10:10', 'Jazz', 2);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (3, 'Bongos', 'I1', 3, 1, 1, 0, '2020-04-06 22:10:10', '2020-05-07 22:10:10', 'Royalty free', 2);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (4, 'Flute', 'E1', 3, 5, 2, 3, '2020-04-07 22:10:10', '2020-05-07 22:10:10', 'House', 3);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (5, 'Beer bottle', 'I1', 3, 1, 1, 0, '2020-04-08 22:10:10', '2020-05-07 22:10:10', 'Soft rock', 3);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (6, 'Flute', 'E2', 3, 10, 2, 2, '2020-04-09 22:10:10', '2020-05-07 22:10:10', 'Pop', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (7, 'Half drum', 'I1', 3, 1, 1, 0, '2020-04-10 22:10:10', '2020-05-07 22:10:10', 'Techno', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (8, 'Flute', 'E3', 3, 10, 2, 2, '2020-04-11 22:10:10', '2020-05-07 22:10:10', 'House', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (9, 'Guiltarr', 'I1', 3, 1, 1, 0, '2020-012-08 22:10:10', '2020-05-07 22:10:10', 'Rap', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (10, 'Flute', 'E1', 3, 4, 2, 0, '2020-04-07 22:10:10', '2020-05-07 22:10:10', 'Jazz', 2);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (11, 'Bongos', 'I1', 3, 1, 1, 0, '2020-08-06 22:10:10', '2020-05-07 22:10:10', 'Royalty free', 2);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (12, 'Flute', 'E1', 3, 5, 2, 0, '2020-05-07 22:10:10', '2020-05-07 22:10:10', 'House', 3);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (13, 'Beer bottle', 'I1', 3, 1, 1, 0, '2020-12-06 22:10:10', '2020-05-07 22:10:10', 'Soft rock', 3);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (14, 'Flute', 'E2', 3, 10, 2, 0, '2020-06-09 22:10:10', '2020-05-07 22:10:10', 'Pop', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (15, 'Half drum', 'I1', 3, 1, 1, 0, '2020-012-08 22:10:10', '2020-05-07 22:10:10', 'Techno', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (16, 'Flute', 'E3', 3, 10, 2, 0, '2020-07-09 22:10:10', '2020-05-07 22:10:10', 'House', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (17, 'Guiltarr', 'I1', 3, 1, 1, 0, '2020-012-08 22:10:10', '2020-05-07 22:10:10', 'Rap', 5);
INSERT INTO `iv1351`.`appointment` (`appointment_id`, `instrument`, `booking_price`, `room_id`, `max`, `min`, `students_registered`, `start_time`, `end_time`, `genre`, `instructor_id`) VALUES (18, 'Flute', 'E3', 3, 10, 2, 0, '2020-07-09 22:10:10', '2020-05-07 22:10:10', 'House', 5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`student`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`student` (`student_id`, `personal_number`, `current_bill`, `sibling_id`) VALUES (2, '234002049356', 0, NULL);
INSERT INTO `iv1351`.`student` (`student_id`, `personal_number`, `current_bill`, `sibling_id`) VALUES (3, '200001011337', 0, NULL);
INSERT INTO `iv1351`.`student` (`student_id`, `personal_number`, `current_bill`, `sibling_id`) VALUES (4, '200101011337', 0, NULL);
INSERT INTO `iv1351`.`student` (`student_id`, `personal_number`, `current_bill`, `sibling_id`) VALUES (5, '200201011337', 0, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`students_attending`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (2, 2);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (3, 2);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (4, 2);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (5, 2);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (2, 4);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (3, 4);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (4, 4);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (2, 6);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (3, 6);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (2, 8);
INSERT INTO `iv1351`.`students_attending` (`student_id`, `appointment_id`) VALUES (4, 8);

COMMIT;


-- -----------------------------------------------------
-- Data for table `iv1351`.`instruments_for_rent`
-- -----------------------------------------------------
START TRANSACTION;
USE `iv1351`;
INSERT INTO `iv1351`.`instruments_for_rent` (`instrument_id`, `brand`, `rental_fee`, `in_stock`, `instrument_type`, `student_id`) VALUES (2, 'Yamaha', 420, 1, 'Beer Bottle', NULL);
INSERT INTO `iv1351`.`instruments_for_rent` (`instrument_id`, `brand`, `rental_fee`, `in_stock`, `instrument_type`, `student_id`) VALUES (3, 'Bosh', 42, 1, 'Drum', NULL);
INSERT INTO `iv1351`.`instruments_for_rent` (`instrument_id`, `brand`, `rental_fee`, `in_stock`, `instrument_type`, `student_id`) VALUES (4, 'Jamahaha', 69, 1, 'Beer Bottle', NULL);
INSERT INTO `iv1351`.`instruments_for_rent` (`instrument_id`, `brand`, `rental_fee`, `in_stock`, `instrument_type`, `student_id`) VALUES (5, 'Shob', 24, 0, 'Ear Drum', 2);

COMMIT;

