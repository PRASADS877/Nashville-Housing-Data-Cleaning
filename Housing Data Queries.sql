------ exploring the data

---- question 1 total number of properties
select count(*) as Total_properties
from housing_data;

---- <<< Question 02 total sales values
select sum(sale_price) as total_sales
from housing_data;

select concat(round(sum(sale_price)/1000000,2),'M') as Total_sales_in_million
from housing_data;

---- question 03 what is the minimum and maximum sales price
select max(sale_price) as Maximum_price,
min(sale_price) as minimum_price
from housing_data;

--- question 04 number of properties per city
select property_city , count(*) as Total_properties
from housing_data
group by property_city
order by total_properties;

---- 05 Avg sales Per_cities
select city ,round(avg(sale_price),2) as Total_sale
from housing_data
group by City
order by Total_sale;

--- 06 Top most Expensive Properties
select * from housing_data
order by sale_price desc
limit 10 ;


---- 07  How can we classify houses based on land value into Low, Mid, and High categories?
SELECT 
  land_value,
  CASE 
    WHEN land_value < 50000 THEN 'Low'
    WHEN land_value BETWEEN 50000 AND 200000 THEN 'Mid'
    ELSE 'High'
  END AS price_category
FROM housing_data
limit 1000;


----- 08 Count of properties sold as vacant vs not
select sold_as_vacant,
count(*) as Total
from housing_data
group by sold_as_vacant;


----- 09 Total sales by year
select year(sale_date) as Year,
sum(sale_price) as Total_sales
from housing_data
group by year
order by year ;

---- 10 Top 5 cities by total revenue
select property_city , sum(sale_price) as Total_Revenue
from housing_data
group by property_city
order by Total_Revenue desc
limit 5 ;

---- 11 Year_over_year growth in sales
SELECT 
YEAR(sale_date) AS year,
SUM(sale_price) AS total_sales,
LAG(SUM(sale_price)) OVER (ORDER BY YEAR(sale_date)) AS prev_year_sales
FROM housing_data
GROUP BY year;

---- 12 Most frequent land use type
select land_use,count(*) as Count
from housing_data
group by land_use
order by count desc
limit 5;

---- 12 Properties with price above average
SELECT *
FROM housing_data
WHERE sale_price > (SELECT AVG(sale_price) FROM housing_data);

---- 13 Does vacant property sell cheaper?
SELECT sold_as_vacant, AVG(sale_price)
FROM housing_data
GROUP BY sold_as_vacant;

----- 14 Which year had highest sales?
SELECT YEAR(sale_date), SUM(sale_price) AS total
FROM housing_data
GROUP BY YEAR(sale_date)
ORDER BY total DESC
LIMIT 1;

--- 15 Top property owners (if repeated)
SELECT owner_name, COUNT(*) AS properties
FROM housing_data
GROUP BY owner_name
ORDER BY properties DESC
LIMIT 10;

--- 16 Rank properties by price within city
SELECT 
property_city,
sale_price,
RANK() OVER (PARTITION BY property_city ORDER BY sale_price DESC) AS rank_in_city
FROM housing_data;

--- 17 running total sales
SELECT 
sale_date,
SUM(sale_price) OVER (ORDER BY sale_date) AS running_total
FROM housing_data;