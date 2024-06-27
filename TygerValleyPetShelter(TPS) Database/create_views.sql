/*
create_views.sql
Programmer: Aundrich Pieterse
Date: 06/06/2024
Description: This script creates the specified views in the TygerValley Pet Shelter database.
*/

/*
NB: I have an updated sql code for the vw_ExpiredFoodDetails view in the Stored Procedures script.
    I have updated it because I encountered an error when i tried to call the sp_Report Stored Procedure. 
*/

USE TygerValleyPetShelter;

-- View for Manufacturer Details
CREATE VIEW vw_ManufacturerDetails AS
SELECT 
    fm.companyName,
    ft.foodName,
    ft.foodID,
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
    Category c ON aq.categoryID = c.categoryID;

-- View for Pets Per Type
CREATE VIEW vw_PetsPerType AS
SELECT 
    pt.animalType,
    pt.totalInStock,
    c.categoryID,
    c.categoryName
FROM 
    PetType pt
JOIN 
    Category c ON pt.categoryID = c.categoryID;

-- View for Expired Food Details
CREATE VIEW vw_ExpiredFoodDetails AS
SELECT 
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
    ft.foodExpiryDate < CURDATE();  -- Use CURDATE() for MySQL to get current date

-- View for Lowest Foods
CREATE VIEW vw_LowestFoods AS
SELECT 
    c.categoryName,
    SUM(pt.totalInStock) AS totalAnimals
FROM 
    PetType pt
JOIN 
    Category c ON pt.categoryID = c.categoryID
GROUP BY 
    c.categoryName
ORDER BY 
    totalAnimals ASC
LIMIT 3;
