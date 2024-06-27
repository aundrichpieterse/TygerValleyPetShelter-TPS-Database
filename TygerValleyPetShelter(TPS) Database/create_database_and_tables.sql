/*
create_database_and_tables.sql
Programmer: Aundrich Pieterse
Date: 06/06/2024
Description: This script creates the TygerValley Pet Shelter database and all 
             necessary tables with constraints, defaults, and indexes.
*/


CREATE DATABASE TygerValleyPetShelter;

USE TygerValleyPetShelter;

-- Table to store information about food manufacturers
CREATE TABLE FoodManufacturer (
    companyID INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(255) NOT NULL,
    contactNumber VARCHAR(15) NOT NULL,
    email VARCHAR(255) NULL -- Email is optional
);

-- Table to store different types of food and their associated manufacturer
CREATE TABLE FoodType (
    foodID INT AUTO_INCREMENT PRIMARY KEY,
    foodName VARCHAR(255) NOT NULL,
    foodExpiryDate DATE NOT NULL,
    foodDescription TEXT,
    measurement VARCHAR(50) NOT NULL,
    companyID INT, -- Foreign key to FoodManufacturer
    CONSTRAINT fk_companyID FOREIGN KEY (companyID) REFERENCES FoodManufacturer(companyID)
);

-- Table to store different categories of animals
CREATE TABLE Category (
    categoryID INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(255) NOT NULL
);

-- Table to store different pet types and their associated category
CREATE TABLE PetType (
    animalType VARCHAR(255) PRIMARY KEY,
    totalInStock INT NOT NULL,
    categoryID INT, -- Foreign key to Category
    CONSTRAINT fk_categoryID FOREIGN KEY (categoryID) REFERENCES Category(categoryID)
);

-- Table to store allocated quantities of food per category
CREATE TABLE AllocatedQuantity (
    foodID INT, -- Foreign key to FoodType
    categoryID INT, -- Foreign key to Category
    allocatedAmount DECIMAL(10,2) NOT NULL, -- e.g., 8.5 kg
    measurement VARCHAR(50) NOT NULL, -- e.g., kg
    PRIMARY KEY (foodID, categoryID),
    CONSTRAINT fk_foodID FOREIGN KEY (foodID) REFERENCES FoodType(foodID),
    CONSTRAINT fk_categoryID_Allocated FOREIGN KEY (categoryID) REFERENCES Category(categoryID)
);

/*
After reading the marksheet I have discovered that the table names must be
lowercase. And for me to update the table names I have used the ALTER statement 
as follows to achieve that.
*/

-- Updating the FoodManufacturer name
ALTER TABLE FoodManufacturer
rename to foodmanufacturer;

-- Updating the FoodType name
ALTER TABLE FoodType
rename to foodtype;

-- Updating the Category name
ALTER TABLE Category
rename to category;

-- Updating the PetType name
ALTER TABLE PetType
rename to pettype;

-- Updating the AllocatedQuantity name
ALTER TABLE AllocatedQuantity
rename to allocatedquantity;