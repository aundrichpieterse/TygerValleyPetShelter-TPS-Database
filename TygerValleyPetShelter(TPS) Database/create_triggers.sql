/*
create_triggers.sql
Programmer: Aundrich Pieterse
Date: 07/06/2024
Description: Creates triggers for the tygervalleypetshelter database
*/

USE TygerValleyPetShelter;

-- trg_AfterInsertFood sends a message when a new food type is added
DELIMITER $$
CREATE TRIGGER trg_AfterInsertFood
AFTER INSERT ON FoodType
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'New food type has been added';
END$$
DELIMITER ;

-- trg_AfterDeleteFood sends a message when a food type is deleted
DELIMITER $$
CREATE TRIGGER trg_AfterDeleteFood
AFTER DELETE ON FoodType
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Food type has been deleted';
END$$

DELIMITER ;
