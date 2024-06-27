/*
insert_data.sql
Programmer: Aundrich Pieterse
Date: 06/06/2024
Description: This script inserts sample data into the TygerValley Pet Shelter database tables.
*/

USE TygerValleyPetShelter;

-- Insert sample data into FoodManufacturer
INSERT INTO FoodManufacturer (companyName, contactNumber, email)
VALUES
    ('Veggie Land', '(051) 861 2571', 'sales@veggieland.co.za'),
    ('Premier Seed Suppliers', '(012) 345 6789', 'contact@premierseeds.co.za'),
    ('Meat Lovers', '(021) 123 4567', NULL), -- Email is optional
    ('Grain House', '(011) 222 3333', 'info@grainhouse.co.za'),
    ('PetFeast', '(011) 444 5555', 'support@petfeast.com');

-- Insert sample data into Category
INSERT INTO Category (categoryName)
VALUES
    ('Mammals'),
    ('Birds'),
    ('Reptiles'),
    ('Fish');

-- Insert sample data into FoodType
INSERT INTO FoodType (foodName, foodExpiryDate, foodDescription, measurement, companyID)
VALUES
    ('Green Vegetable Mix', '2023-05-31', 'Fresh green vegetables mix', 'kg', 1),
    ('Seeds', '2024-08-15', 'Various seeds for birds', 'kg', 2),
    ('Beef Chunks', '2023-09-30', 'Fresh beef chunks', 'kg', 3),
    ('Whole Grains', '2024-01-31', 'Assorted whole grains', 'kg', 4),
    ('Fish Flakes', '2024-07-20', 'Fish food flakes', 'kg', 5),
    ('Carrots', '2023-04-01', 'Fresh carrots', 'kg', 1),
    ('Bird Pellets', '2024-09-10', 'Pellet food for birds', 'kg', 2);

-- Insert sample data into PetType
INSERT INTO PetType (animalType, totalInStock, categoryID)
VALUES
    ('Dog', 10, 1),
    ('Cat', 20, 1),
    ('Parrot', 40, 2),
    ('Snake', 5, 3),
    ('Goldfish', 50, 4),
    ('Hamster', 15, 1),
    ('Canary', 25, 2),
    ('Lizard', 7, 3);

-- Insert sample data into AllocatedQuantity
INSERT INTO AllocatedQuantity (foodID, categoryID, allocatedAmount, measurement)
VALUES
    (1, 1, 50.0, 'kg'),
    (2, 2, 30.0, 'kg'),
    (3, 1, 60.0, 'kg'),
    (4, 1, 40.0, 'kg'),
    (5, 4, 25.0, 'kg'),
    (6, 3, 20.0, 'kg'),
    (7, 2, 35.0, 'kg');