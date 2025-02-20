--Analysing dataset from walmartsales to capture sensitive purchases and unique product itemsdemo
SELECT * from WalmartSalesDatacsv;

SELECT 
	time,
    (CASE
     	WHEN time BETWEEN '00:00:00' ANd '12:00:00' Then 'Morining'
     	WHEN time BETWEEN '12:01:00' ANd '16:00:00' Then 'Afternoon'
     ELSE
     	'Evening'
     end) as time_of_day
from WalmartSalesDatacsv;

Alter TABLE WalmartSalesDatacsv add  time_of_day VARCHAR(20);

UPDATE WalmartSalesDatacsv 
set time_of_day = (
CASE
     	WHEN time BETWEEN '00:00:00' ANd '12:00:00' Then 'Morining'
     	WHEN time BETWEEN '12:01:00' ANd '16:00:00' Then 'Afternoon'
     ELSE
     	'Evening'
     end
);


------------------------------------------------------------------
-----Adding a new column called day_name-----
SELECT 
	DATENAME(weekday,date) as Day_Name
from WalmartSalesDatacsv;

ALTER TABLE WalmartSalesDatacsv add Day_name VARCHAR(20);
UPDATE WalmartSalesDatacsv
set day_name = DATENAME(weekday, date);

--updating the table with new column called month_name
SELECT DATENAME(month, date) as Month_name
from WalmartSalesDatacsv;

ALTER TABLE WalmartSalesDatacsv add month_name VARCHAR(15); 
UPDATE WalmartSalesDatacsv
set month_name = DATENAME(month, date);
----------------------------------------

---Generic Question---
---How many unique cities does the data have?
SELECT
	DISTINCT(city) as cities
    from 
    WalmartSalesDatacsv;
    
--In which city is each branch?
SELECT 
	DISTINCT(city) AS cnt,
    branch
FROM WalmartSalesDatacsv;

---PRODUCT-----
---How many unique product lines does the data have?
SELECT 
	count(DISTINCT product_line) as cnt_of_product
    from 
    WalmartSalesDatacsv;

--What is the most common payment method?
SELECT payment,
	COUNT(payment) as cnt_of_payment
from WalmartSalesDatacsv
GROUP by payment
ORDER by cnt_of_payment DESC;


--What is the most selling product line?
SELECT 
	product_line,
	count(product_line) as cnt_of_product
    from 
    WalmartSalesDatacsv
GROUP by product_line
ORDER by cnt_of_product DESC;
--The most selling product line is Fashion accessories


--What is the total revenue by month?
SELECT 
	month_name,
	SUM(total) as total_per_month
from WalmartSalesDatacsv
GROUP by month_name
ORDER by total_per_month DESC;


---What month had the largest COGS?
SELECT 
	month_name,
	ROUND(SUM(cogs),4) as total_per_month
from WalmartSalesDatacsv
GROUP by month_name
ORDER by total_per_month DESC;


--What product line had the largest revenue?
SELECT 
	product_line,
    sum(total) as tot_revenue
    FROM WalmartSalesDatacsv
group by product_line
ORDER by tot_revenue desc;

--What is the city with the largest revenue?
SELECT 
	city,
    branch,
    sum(total) as tot_revenue
    FROM WalmartSalesDatacsv
group by city, branch
ORDER by tot_revenue desc;


--What product line had the largest VAT?
SELECT product_line, AVG(tax_5%) as avg_tax OVER(PARTITION BY product_line ORDER by avg_tax) from WalmartSalesDatacsv



--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

--SELECT product_line, AVG(total) as avg_sales
--from WalmartSalesDatacsv
--group by product_line;

WITH avg_per_sales AS (
    SELECT product_line, AVG(total) AS avg_sales
    FROM WalmartSalesDatacsv
    GROUP BY product_line
),
overall_avg AS (
    SELECT AVG(total) AS overall_avg_sales
    FROM WalmartSalesDatacsv
)
SELECT aps.product_line, aps.avg_sales, oa.overall_avg_sales,
  CASE 
    WHEN aps.avg_sales > oa.overall_avg_sales THEN 'Good'
    ELSE 'Bad'
  END AS trend
FROM avg_per_sales aps, overall_avg oa
ORDER BY aps.product_line DESC;

