-- Nashville Housing Data Cleaning Project
-- Author: Prasad S

--------------------------------------------------
-- 01. Create Database
--------------------------------------------------
CREATE DATABASE Nashville_Housing_data;
USE Nashville_Housing_data;

--------------------------------------------------
-- 02. Initial Data Exploration
--------------------------------------------------
SELECT COUNT(*) AS total_rows FROM housing;

SELECT COUNT(*) AS total_columns
FROM information_schema.columns
WHERE table_name = 'housing';

--------------------------------------------------
-- 03. Create Working Table
--------------------------------------------------
CREATE TABLE housing_data LIKE housing;

INSERT INTO housing_data
SELECT * FROM housing;

--------------------------------------------------
-- 04. Drop Unnecessary Columns
--------------------------------------------------
ALTER TABLE housing_data
DROP COLUMN `MyUnknownColumn`,
DROP COLUMN `Unnamed: 0`,
DROP COLUMN `Suite/ Condo   #`,
DROP COLUMN `image`;

--------------------------------------------------
-- 05. Rename Columns (Standardization)
--------------------------------------------------
ALTER TABLE housing_data
RENAME COLUMN `Parcel ID` TO parcel_id,
RENAME COLUMN `Land Use` TO land_use,
RENAME COLUMN `Property Address` TO property_address,
RENAME COLUMN `Property City` TO property_city,
RENAME COLUMN `Sale Date` TO sale_date,
RENAME COLUMN `Sale Price` TO sale_price,
RENAME COLUMN `Legal Reference` TO legal_reference,
RENAME COLUMN `Sold As Vacant` TO sold_as_vacant,
RENAME COLUMN `Owner Name` TO owner_name;

--------------------------------------------------
-- 06. Convert Date Format
--------------------------------------------------
UPDATE housing_data
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%Y');

ALTER TABLE housing_data
MODIFY sale_date DATE;

--------------------------------------------------
-- 07. Remove Duplicates
--------------------------------------------------
ALTER TABLE housing_data
ADD id INT AUTO_INCREMENT PRIMARY KEY;

WITH cte AS (
    SELECT id,
           ROW_NUMBER() OVER (
               PARTITION BY parcel_id, property_address, sale_price, sale_date, legal_reference
               ORDER BY id
           ) AS rn
    FROM housing_data
)
DELETE FROM housing_data
WHERE id IN (
    SELECT id FROM cte WHERE rn > 1
);

--------------------------------------------------
-- 08. Handle Missing & Blank Values
--------------------------------------------------

-- Convert blanks to NULL
UPDATE housing_data
SET 
property_address = NULLIF(TRIM(property_address), ''),
property_city = NULLIF(TRIM(property_city), ''),
owner_name = NULLIF(TRIM(owner_name), '');

-- Remove critical missing rows
DELETE FROM housing_data
WHERE property_address IS NULL
   OR property_city IS NULL;

-- Replace large missing values
UPDATE housing_data
SET owner_name = 'Unknown'
WHERE owner_name IS NULL;

--------------------------------------------------
-- 09. Clean Numeric Columns
--------------------------------------------------
UPDATE housing_data
SET land_value = REPLACE(land_value, ',', '');

ALTER TABLE housing_data MODIFY land_value INT;

--------------------------------------------------
-- 10. Fill Missing Numeric Values
--------------------------------------------------
UPDATE housing_data
SET land_value = COALESCE(land_value, 69145);

--------------------------------------------------
-- 11. Final Validation
--------------------------------------------------
SELECT *
FROM housing_data
WHERE property_address IS NULL
   OR property_city IS NULL
   OR owner_name IS NULL;
