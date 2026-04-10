create database Nashville_Housing_data;
use Nashville_Housing_data;
--- Total rows is 56636 
select count(*) as Total_rows
from housing;

---- Total columns 
select count(*) as Total_column
from information_schema.columns
where table_name = 'housing';


----- Cleanning the data 
----- removing the duplicate records 
----- replacing the values or blanks 
----- coverting the right datatypes 
---- deleting the unnecessary columns 


----- 01 -- Data Cleaning Step:


--- Firstly , I created another table from the original Hosing table so that if I make any mistakes while cleaning or updating data,
-- I can always go back and check the original raw table. This helps me keep the original data safe..

create table Housing_Data
like housing;
select * from housing_data;

--- inserting the data from Housing 
insert housing_data
select * from housing;

select * from housing_data;
----- SECOND STEP <<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Dropped irrelevant and redundant columns (MyUnknownColumn, Unnamed: 0, Suite/Condo, Image)
-- These columns contained either system-generated values, duplicate identifiers, or non-analytical data
-- to improve dataset quality and query performance

alter table housing_data
drop column`MyUnknownColumn`,
drop column `Unnamed: 0`,
drop column `Suite/ Condo   #`,
drop column `image`;

---- 3rd Steps -----<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>
-- Renaming columns
-- Reason:
-- 1. Remove spaces in column names
-- 2. Improve readability and consistency
-- 3. Follow standard naming convention (snake_case)
-- 4. Make querying easier and avoid syntax issues

-- Example: "Owner Name" → owner_name
--          "Sale Date" → sale_date

alter table housing_data
rename column `Parcel ID` to parcel_id,
rename column `Land Use` to land_use,
rename column `Property Address` to property_address,
rename column `Property City` to property_city,
rename column `Sale Date` to sale_date,
rename column `Sale Price` to sale_price,
rename column `Legal Reference` to legal_reference,
rename column `Sold As Vacant` to sold_as_vacant,
rename column`Multiple Parcels Involved in Sale`to multiple_parcels_involved_sales,
rename column `Owner Name` to owner_name,
rename column`Tax District` to tax_district,
rename column `Land Value` to land_value,
rename column`Building Value` to building_value,
rename column `Total Value` to total_value,
rename column `Finished Area` to finished_area,
rename column `Foundation Type` to foundation_type,
rename column `Year Built` to year_built,
rename column `Exterior Wall` to exterior_wall,
rename column `Full Bath` to full_bath,
rename column `Half Bath`to half_bath;

------  4th STEPS Date Conversion <<<<>><<<>>><<<>><<<>><<>><<>><<>><<>><<>><<>>
-- Transformed sale_date column from TEXT to DATE datatype using STR_TO_DATE
-- to improve data consistency, accuracy, and support time-based analysisinto date format
select sale_date from housing_data
limit 1000;
SELECT DISTINCT sale_date 
FROM housing_data 
LIMIT 20;

UPDATE housing_data
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%Y');

---- changing data type
alter table housing_data
modify sale_date date;

---- 5th STEPS Checking Duplicates records
select parcel_id,property_address,sale_price,sale_date,legal_reference,
count(*) as Duplicant_count
from housing_data
group by 
parcel_id,property_address,sale_price,sale_date,legal_reference
having count(*) >1;

----- Step 5(1) count total duplicate rows
SELECT COUNT(*) AS total_duplicates
FROM (
    SELECT 
        parcel_id,
        property_address,
        sale_price,
        sale_date,
        legal_reference,
        COUNT(*) AS cnt
    FROM housing_data
    GROUP BY 
        parcel_id,
        property_address,
        sale_price,
        sale_date,
        legal_reference
    HAVING COUNT(*) > 1
) AS duplicates;
---- total have 104 duplicates rcords 


SELECT 
parcel_id,
COUNT(DISTINCT sale_date) AS unique_dates,
COUNT(DISTINCT legal_reference) AS unique_refs
FROM housing_data
GROUP BY parcel_id
HAVING COUNT(*) > 1;
---------- <<<<<<<<<<<<<< final check duplicates 
SELECT 
parcel_id,
property_address,
sale_price,
sale_date,
legal_reference,
COUNT(*) AS cnt
FROM housing_data
GROUP BY 
parcel_id, property_address, sale_price, sale_date, legal_reference
HAVING COUNT(*) > 1;


----- deleting duplicates
ALTER TABLE housing_data
ADD id INT AUTO_INCREMENT PRIMARY KEY;

WITH cte AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (
            PARTITION BY 
                parcel_id, 
                property_address, 
                sale_price, 
                sale_date, 
                legal_reference
            ORDER BY id
        ) AS rn
    FROM housing_data
)

DELETE FROM housing_data
WHERE id IN (
    SELECT id FROM cte WHERE rn > 1
);


---- verifying 
SELECT 
parcel_id,
COUNT(*) 
FROM housing_data
GROUP BY 
parcel_id, property_address, sale_price, sale_date, legal_reference
HAVING COUNT(*) > 1;


------ 06 steps checking null values 
SELECT 
COUNT(*) AS total_rows,

SUM(CASE WHEN parcel_id IS NULL THEN 1 ELSE 0 END) AS null_parcel_id,
SUM(CASE WHEN property_address IS NULL THEN 1 ELSE 0 END) AS null_property_address,
SUM(CASE WHEN sale_price IS NULL THEN 1 ELSE 0 END) AS null_sale_price,
SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS null_sale_date,
SUM(CASE WHEN legal_reference IS NULL THEN 1 ELSE 0 END) AS null_legal_reference,
SUM(CASE WHEN owner_name IS NULL THEN 1 ELSE 0 END) AS null_owner_name

FROM housing_data;

select * from housing_data
limit 1500;

---- check nulls in all important column 
SELECT *
FROM housing_data
WHERE 
parcel_id IS NULL OR
property_address IS NULL OR
property_city IS NULL OR
sale_price IS NULL OR
sale_date IS NULL OR
legal_reference IS NULL OR
owner_name IS NULL;

---
SELECT COUNT(*)
FROM housing_data
WHERE 
parcel_id IS NULL OR
property_address IS NULL OR
property_city IS NULL OR
sale_price IS NULL OR
sale_date IS NULL OR
legal_reference IS NULL OR
owner_name IS NULL;


----- check blanks and replace <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT *
FROM housing_data
WHERE 
TRIM(property_address) = '' OR
TRIM(owner_name) = '' OR
TRIM(property_city) = '';

-----  count blanks 
SELECT 
SUM(CASE WHEN TRIM(property_address) = '' THEN 1 ELSE 0 END) AS blank_address,
SUM(CASE WHEN TRIM(owner_name) = '' THEN 1 ELSE 0 END) AS blank_owner,
SUM(CASE WHEN TRIM(property_city) = '' THEN 1 ELSE 0 END) AS blank_city
FROM housing_data;

---- Convert All Blanks → NULL
UPDATE housing_data
SET 
property_address = NULLIF(TRIM(property_address), ''),
property_city = NULLIF(TRIM(property_city), ''),
owner_name = NULLIF(TRIM(owner_name), '');

----- Handle SMALL Missing Data (Address & City)
DELETE FROM housing_data
WHERE property_address IS NULL
   OR property_city IS NULL;
   
   --- Handle LARGE Missing Data (Owner Name)
   update housing_data
   set owner_name = 'Unknown'
   where owner_name is null;
   
   ---- final check table
   SELECT 
COUNT(*) 
FROM housing_data
WHERE 
property_address IS NULL 
OR property_city IS NULL 
OR owner_name IS NULL;


------- i Performed complete data cleaning on housing dataset
-- Removed irrelevant columns and standardized column names
-- Converted sale_date to proper DATE format
-- Identified and removed duplicate records
-- Handled missing values by converting blanks to NULL
-- Removed low-volume missing records and replaced high-volume missing values with 'Unknown'
-- Validated dataset to ensure no NULL or blank values remain