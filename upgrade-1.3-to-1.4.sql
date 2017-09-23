ALTER TABLE `police` CHANGE COLUMN `rank` `rank` VARCHAR(255) NULL;

UPDATE `police` SET `rank` = null;

ALTER TABLE `police` CHANGE COLUMN `rank` `rank` INT(11) NULL DEFAULT '0' ;

UPDATE `police` SET `rank` = 0;

ALTER TABLE `police` CHANGE COLUMN `rank` `rank` INT(11) NOT NULL DEFAULT '0' ;