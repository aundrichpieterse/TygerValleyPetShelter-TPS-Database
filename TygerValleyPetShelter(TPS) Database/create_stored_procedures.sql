/*
create_stored_procedures.sql
Programmer: Aundrich Pieterse
Date: 07/06/2024
Description: This script creates stored procedures for the TygerValley Pet Shelter database.
*/

USE TygerValleyPetShelter;

-- This stored procedure inserts a new pet type record
DELIMITER //

CREATE PROCEDURE sp_NewPetType (
    IN p_animalType VARCHAR(255),
    IN p_totalInStock INT,
    IN p_categoryID INT
)
BEGIN
    DECLARE categoryExists INT;

    -- Check if the categoryID exists in the Category table
    SELECT COUNT(*)
    INTO categoryExists
    FROM Category
    WHERE categoryID = p_categoryID;

    -- If the categoryID does not exist, signal an error
    IF categoryExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Category ID does not exist.';
    ELSE
        -- Insert the new pet type record
        INSERT INTO PetType (animalType, totalInStock, categoryID)
        VALUES (p_animalType, p_totalInStock, p_categoryID);
    END IF;
END //

DELIMITER ;

/*
Example execution of sp_NewPetType
This call inserts a new pet type record
*/
CALL sp_NewPetType('Bird', 20, 1);

-- This stored procedure updates an existing pet type record
DELIMITER //

CREATE PROCEDURE sp_UpdateStock (
    IN p_animalType VARCHAR(255),
    IN p_stockChange INT,
    IN p_operation BIT
)
BEGIN
    DECLARE currentStock INT;
    DECLARE newStock INT;

    -- Fetch the current stock for the specified pet type
    SELECT totalInStock
    INTO currentStock
    FROM PetType
    WHERE animalType = p_animalType;

    -- Determine the new stock based on the operation (1 for addition, 0 for subtraction)
    IF p_operation = 1 THEN
        SET newStock = currentStock + p_stockChange;
    ELSE
        SET newStock = currentStock - p_stockChange;
    END IF;

    -- Ensure the new stock is not negative
    IF newStock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock cannot be negative.';
    ELSE
        -- Update the pet type record with the new stock value
        UPDATE PetType
        SET totalInStock = newStock
        WHERE animalType = p_animalType;
    END IF;
END //

DELIMITER ;

/*
Example execution of sp_UpdateStock
This call updates the stock for a specified pet type
*/
CALL sp_UpdateStock('Bird', 5, 1); -- Adds 5 to the current stock
CALL sp_UpdateStock('Bird', 3, 0); -- Subtracts 3 from the current stock

-- This stored procedure deletes a specified food type
DELIMITER //

CREATE PROCEDURE sp_DeleteFoodType (
    IN p_foodID INT
)
BEGIN
    DECLARE foodExists INT;

    -- Check if the foodID exists in the vw_ExpiredFoodDetails view
    SELECT COUNT(*)
    INTO foodExists
    FROM vw_ExpiredFoodDetails
    WHERE foodID = p_foodID;

    -- If the foodID exists in the view, delete the food type and its dependent records
    IF foodExists > 0 THEN
        DELETE FROM AllocatedQuantity
        WHERE foodID = p_foodID;

        DELETE FROM FoodType
        WHERE foodID = p_foodID;
    ELSE
        -- Signal an error if the foodID does not exist in the view
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Food ID not found in expired food details.';
    END IF;
END //

DELIMITER ;

/*
Example execution of sp_DeleteFoodType
This call deletes a specified food type and its dependent records
*/
CALL sp_DeleteFoodType(1);

/*
-- This stored procedure generates an expired products report for a specified manufacturing company.
-- NB: Updated SQL code is at the end of the script. The reason for the update is because I got an error when i tried to call the sp_Report
DELIMITER //

CREATE PROCEDURE sp_Report (
    IN p_companyID INT
)
BEGIN
    DECLARE companyName VARCHAR(255);
    DECLARE contactNumber VARCHAR(20);
    DECLARE email VARCHAR(255);
    DECLARE totalRecords INT DEFAULT 0;

    -- Fetch the company details
    SELECT companyName, contactNumber, email
    INTO companyName, contactNumber, email
    FROM FoodManufacturer
    WHERE companyID = p_companyID;

    -- Count the total records for the specified company
    SELECT COUNT(*)
    INTO totalRecords
    FROM vw_ExpiredFoodDetails
    WHERE companyID = p_companyID;

    -- Generate and print the report
    SELECT CONCAT('EXPIRED PRODUCTS REPORT:\n',
                  '__________________________________________________\n',
                  'Generated: ', DATE_FORMAT(NOW(), '%b %d %Y %l:%i%p'), '\n',
                  'Company ID: ', p_companyID, '\n',
                  'Company Name: ', companyName, '\n',
                  'Contact Number: ', contactNumber, '\n',
                  'Email: ', IFNULL(email, 'N/A'), '\n',
                  '__________________________________________________\n',
                  'Food ID   Food Type\n',
                  '__________________________________________________') AS ReportHeader
    UNION ALL
    SELECT CONCAT(foodID, '        ', foodName)
    FROM vw_ExpiredFoodDetails
    WHERE companyID = p_companyID
    UNION ALL
    SELECT CONCAT('____________________\nTotal Records: ', totalRecords);
END //

DELIMITER ;

-- Example execution of sp_Report
-- This call generates an expired products report for the manufacturing company with ID 2.

CALL sp_Report(2);
*/

-- updated view for vw_ExpiredFoodDetails
CREATE OR REPLACE VIEW vw_ExpiredFoodDetails AS
SELECT 
    fm.companyID,
    fm.companyName,
    fm.contactNumber,
    ft.foodID,
    ft.foodName,
    ft.foodExpiryDate,
    aq.allocatedAmount,
    aq.measurement,
    c.categoryName
FROM 
    FoodManufacturer fm
JOIN 
    FoodType ft ON fm.companyID = ft.companyID
JOIN 
    AllocatedQuantity aq ON ft.foodID = aq.foodID
JOIN 
    Category c ON aq.categoryID = c.categoryID
WHERE 
    ft.foodExpiryDate < CURDATE();  -- Use CURDATE() to get current date

-- Updated sp_Report Stored Procedure
DELIMITER //

CREATE PROCEDURE sp_Report (
    IN p_companyID INT
)
BEGIN
    DECLARE companyName VARCHAR(255);
    DECLARE contactNumber VARCHAR(20);
    DECLARE email VARCHAR(255);
    DECLARE totalRecords INT DEFAULT 0;

    -- Fetch the company details
    SELECT companyName, contactNumber, email
    INTO companyName, contactNumber, email
    FROM FoodManufacturer
    WHERE companyID = p_companyID;

    -- Count the total records for the specified company
    SELECT COUNT(*)
    INTO totalRecords
    FROM vw_ExpiredFoodDetails
    WHERE companyID = p_companyID;

    -- Generate and print the report
    SELECT CONCAT('EXPIRED PRODUCTS REPORT:\n',
                  '__________________________________________________\n',
                  'Generated: ', DATE_FORMAT(NOW(), '%b %d %Y %l:%i%p'), '\n',
                  'Company ID: ', p_companyID, '\n',
                  'Company Name: ', companyName, '\n',
                  'Contact Number: ', contactNumber, '\n',
                  'Email: ', IFNULL(email, 'N/A'), '\n',
                  '__________________________________________________\n',
                  'Food ID   Food Type\n',
                  '__________________________________________________') AS ReportHeader
    UNION ALL
    SELECT CONCAT(foodID, '        ', foodName)
    FROM vw_ExpiredFoodDetails
    WHERE companyID = p_companyID
    UNION ALL
    SELECT CONCAT('____________________\nTotal Records: ', totalRecords);
END //

DELIMITER ;

-- Example execution of sp_Report
-- This call generates an expired products report for the manufacturing company with ID 2.
CALL sp_Report(1);