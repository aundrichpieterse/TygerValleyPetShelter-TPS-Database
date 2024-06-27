/*
create_indexes.sql
Programmer: Aundrich Pieterse
Date: 07/06/2024
Description: Creates indexes for the TygerValleyPetShelter database
*/

USE TygerValleyPetShelter;

-- Index on company name in FoodManufacturer
CREATE INDEX idx_ManufacturerName ON FoodManufacturer(companyName);

-- Index on food name in FoodType
CREATE INDEX idx_FoodName ON FoodType(foodName);

-- Index on category name in Category
CREATE INDEX idx_CategoryName ON Category(categoryName);

-- Index on animal type in PetType
CREATE INDEX idx_PetTypeName ON PetType(animalType);
