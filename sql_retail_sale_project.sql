CREATE DATABASE Retail_Sales_Project;
USE Retail_Sales_Project;

CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
    sale_date DATE,
     sale_time TIME, 	
    customer_id	INT,
    gender VARCHAR(15),
    age	INT,
    category VARCHAR(15),	
    quantiy	INT,
    price_per_unit INT,
    cogs FLOAT,	
    total_sale FLOAT
    );
    
-- Verifing the number of rows imported from the dataset 
SELECT COUNT(*) 
    FROM retail_sales;
    
-- Removing any data with zero in the cell (Data Cleaning)
DELETE FROM retail_sales
WHERE transactions_id= '0' OR
     sale_time= '0' OR	
    customer_id= '0' OR
    gender= NULL OR
    category= NULL OR	
    quantiy= '0' OR
    price_per_unit= '0' OR
    cogs= '0' OR
    total_sale= '0';

-- Date Exploration 
-- customers we have 
SELECT COUNT(DISTINCT(customer_id)) AS total_sales
FROM retail_sales;

-- retrieve coulms for sales on '2022-11-05'
SELECT sale_date, total_sale
FROM retail_sales 
WHERE sale_date= '2022-11-05';

-- sum of sales made on '2022-11-05'
SELECT sale_date, SUM(total_sale)
FROM retail_sales
WHERE sale_date= '2022-11-05'
GROUP BY sale_date;

-- sale data from novemeber month for clothes and when 4 or more ordered
SELECT *
FROM retail_sales
WHERE (sale_date >='2022-11-01' AND sale_date<= '2022-11-30') AND category= 'Clothing' AND quantiy >= '4' ;

-- total sales from each category 
SELECT category, SUM(total_sale) AS sale_by_category, COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category;

-- average customer age for beauty category 
SELECT category, ROUND(AVG(age),0)
FROM retail_sales
WHERE category= 'beauty'
GROUP BY category;

-- all trnasaction with total_sale greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > '1000';

-- # of tranasaction by each geneder in each category 

SELECT category, 
		gender, 
        COUNT(*) as total_transaction
FROM retail_sales 
GROUP BY category, gender
ORDER BY gender, category;

-- avergae sales for each month and find the best selling month for each year
SELECT ranking, avg_sales, year, month
FROM(
SELECT 
	YEAR(sale_date) AS year, 
    MONTH(sale_date) AS month, 
    ROUND(AVG(total_sale), 2) as avg_sales,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS ranking
FROM retail_sales
GROUP BY year, month
) AS T1
WHERE ranking= '1'

; 

-- top 5 customers with highest sales 
SELECT customer_id, SUM(total_sale) AS highest_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY highest_sale desc
LIMIT 5
;

-- # of unique customers who purchased items from each category 
SELECT COUNT(distinct(customer_id)) AS count_unique_customer, category
FROM retail_sales
GROUP BY category;

-- create each sift (morning, evening, afternoon) and number of orders 
SELECT 	
	CASE 
			WHEN HOUR(sale_time) < 12 THEN 'morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
			ELSE 'evening'
	END AS shift,
		COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY shift 
