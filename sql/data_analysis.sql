-- Nashville Housing Data Analysis
-- Author: Prasad S

--------------------------------------------------
-- 01. Total number of properties
--------------------------------------------------
SELECT COUNT(*) AS total_properties
FROM housing_data;

--------------------------------------------------
-- 02. Total sales value
--------------------------------------------------
SELECT SUM(sale_price) AS total_sales
FROM housing_data;

SELECT CONCAT(ROUND(SUM(sale_price)/1000000,2),' M') AS total_sales_millions
FROM housing_data;

--------------------------------------------------
-- 03. Min & Max sale price
--------------------------------------------------
SELECT 
MAX(sale_price) AS max_price,
MIN(sale_price) AS min_price
FROM housing_data;

--------------------------------------------------
-- 04. Properties per city
--------------------------------------------------
SELECT property_city, COUNT(*) AS total_properties
FROM housing_data
GROUP BY property_city
ORDER BY total_properties DESC;

--------------------------------------------------
-- 05. Avg sale price per city
--------------------------------------------------
SELECT property_city, ROUND(AVG(sale_price),2) AS avg_price
FROM housing_data
GROUP BY property_city
ORDER BY avg_price DESC;

--------------------------------------------------
-- 06. Top 10 expensive properties
--------------------------------------------------
SELECT *
FROM housing_data
ORDER BY sale_price DESC
LIMIT 10;

--------------------------------------------------
-- 07. Price category (land value)
--------------------------------------------------
SELECT 
land_value,
CASE 
    WHEN land_value < 50000 THEN 'Low'
    WHEN land_value BETWEEN 50000 AND 200000 THEN 'Mid'
    ELSE 'High'
END AS price_category
FROM housing_data;

--------------------------------------------------
-- 08. Vacant vs Non-vacant
--------------------------------------------------
SELECT sold_as_vacant, COUNT(*) AS total
FROM housing_data
GROUP BY sold_as_vacant;

--------------------------------------------------
-- 09. Sales by year
--------------------------------------------------
SELECT YEAR(sale_date) AS year, SUM(sale_price) AS total_sales
FROM housing_data
GROUP BY year
ORDER BY year;

--------------------------------------------------
-- 10. Top 5 cities by revenue
--------------------------------------------------
SELECT property_city, SUM(sale_price) AS total_revenue
FROM housing_data
GROUP BY property_city
ORDER BY total_revenue DESC
LIMIT 5;

--------------------------------------------------
-- 11. Year-over-year growth
--------------------------------------------------
SELECT 
YEAR(sale_date) AS year,
SUM(sale_price) AS total_sales,
LAG(SUM(sale_price)) OVER (ORDER BY YEAR(sale_date)) AS prev_year_sales
FROM housing_data
GROUP BY year;

--------------------------------------------------
-- 12. Properties above average price
--------------------------------------------------
SELECT *
FROM housing_data
WHERE sale_price > (SELECT AVG(sale_price) FROM housing_data);

--------------------------------------------------
-- 13. Most frequent land use
--------------------------------------------------
SELECT land_use, COUNT(*) AS count
FROM housing_data
GROUP BY land_use
ORDER BY count DESC
LIMIT 5;

--------------------------------------------------
-- 14. Vacant property price comparison
--------------------------------------------------
SELECT sold_as_vacant, AVG(sale_price) AS avg_price
FROM housing_data
GROUP BY sold_as_vacant;

--------------------------------------------------
-- 15. Highest sales year
--------------------------------------------------
SELECT YEAR(sale_date), SUM(sale_price) AS total
FROM housing_data
GROUP BY YEAR(sale_date)
ORDER BY total DESC
LIMIT 1;

--------------------------------------------------
-- 16. Top property owners
--------------------------------------------------
SELECT owner_name, COUNT(*) AS properties
FROM housing_data
GROUP BY owner_name
ORDER BY properties DESC
LIMIT 10;

--------------------------------------------------
-- 17. Rank by price within city
--------------------------------------------------
SELECT 
property_city,
sale_price,
RANK() OVER (PARTITION BY property_city ORDER BY sale_price DESC) AS rank_in_city
FROM housing_data;

--------------------------------------------------
-- 18. Running total sales
--------------------------------------------------
SELECT 
sale_date,
SUM(sale_price) OVER (ORDER BY sale_date) AS running_total
FROM housing_data;
