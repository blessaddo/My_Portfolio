select * from child_mortality_rate;

/*Can you write a SQL query to count the number of unique countries 
in the dataset and get the earliest 
and latest years for which data is available?*/

SELECT entity , MIN(year) as earliest , MAX(year) as latest FROM child_mortality_rate
GROUP by entity;

/*Write a query to find any records where the under-five
mortality rate is negative or above 1000. 
This could help identify potential data entry errors.*/
--No records shows negative  
SELECT * from child_mortality_rate;
WHERE under_five__mortality_rate < 0 or under_five__mortality_rate > 1000;

/*How would you write a query to see the trend of under-five mortality rate over
the years for a specific country?*/

SELECT year, ROUND(AVG(under_five__mortality_rate),2) as avg_mortality_rate
from child_mortality_rate
where entity =  'Ghana'
GROUP by year 
ORDER by year DESC, avg_mortality_rate desc;

/* Can you write a query to compare the under-five mortality rate between 
two specific countries?*/

SELECT entity, ROUND(AVG(under_five__mortality_rate), 2) as rate_per, year as rate_of_death
FROM child_mortality_rate
where entity IN ('Ghana' , 'Gambia')
GROUP by entity, rate_of_death
ORDER by entity, rate_of_death;

--Write a SQL query to identify any years
--for which data is missing for a specific country.

SELECT * FROM child_mortality_rate;

SELECT year 
	from 
	(SELECT  year from child_mortality_rate where entity = 'Ghana' GROUP by year)
WHERE not EXISTS
	(SELECT 1 FROM child_mortality_rate WHERE entity = 'Ghana' and year);

--Can you calculate the average under-five mortality 
--rate for all the countries in the dataset?
SELECT entity as countries , AVG(under_five__mortality_rate) as avg_0f_death_per_country
FROM child_mortality_rate
GROUP by countries
ORDER by countries;

SELECT entity , AVG(under_five__mortality_rate) OVER (PARTITION BY entity ORDER by entity) as avg_0f_death_per_country
FROM child_mortality_rate;


--Write a query to find the top five and bottom five countries with the highest 
--and lowest under-five mortality rates, respectively.

SELECT  entity , MAX(under_five__mortality_rate) OVER (PARTITION BY entity ) as higest_countries_death , 
MIN(under_five__mortality_rate) over (PARTITION BY entity) as lowest_countries_death
from child_mortality_rate ;

select entity as country , under_five__mortality_rate from child_mortality_rate
ORDER by under_five__mortality_rate
LIMIT 5
UNION 
SELECT entity as country, under_five__mortality_rate from child_mortality_rate
ORDER by under_five__mortality_rate desc 
LIMIT 5 desc;


--Can you group the data by regions (if defined) and 
--calculate the average under-five mortality rate for each region?
select code, ROUND(AVG(under_five__mortality_rate),4) as avg_mortality from child_mortality_rate
where code Is not  NULL
GROUP by code
ORDER by code;

--Write a query to find the countries with the highest and 
--lowest yearly changes in the under-five mortality rate.

WITH country_year_data (
  entity, year, under_five__mortality_rate FROM child_mortality_rate),
  yearly_changes as (SELECT country, year, under_five__mortality_rate,
                     (LAG(under_five__mortality_rate) OVER (PARTITION BY country ORDER by year)
                      - under_five__mortality_rate) as yearly_changes
                     from country_year_data)
                     
SELECT country MAX(yearly_changes) as max_yearly_changes, MIN(yearly_changes) as min_yearly_change
FROM 
  yearly_changes
GROUP BY country
ORDER BY max_yearly_changes DESC, in_yearly_changes ASC
LIMIT 1;


--Can you write a query to 
--validate if the under-five mortality rate is consistently decreasing 
--or stable over the years for a specific country? 
--dden increases might indicate errors or special cases.

with under_five__mortality_rate as 

(select entity  ,year,  AVG(under_five__mortality_rate) as avg_mortality_rate
from child_mortality_rate
group by entity , year),

overall_avg AS (
    SELECT 
      entity, 
      AVG(avg_mortality_rate) AS overall_avg_mortality_rate
    FROM 
      child_mortality_rate
    GROUP BY 
      entity
  )
    
SELECT entity, year, avg_mortality_rate, overall_avg_mortality_rate,
  CASE 
    WHEN avg_mortality_rate < overall_avg_mortality_rate THEN 'Decreasing'
    WHEN avg_mortality_rate > overall_avg_mortality_rate THEN 'Increasing'
    ELSE 'Stable'
  END AS trend
FROM 
  child_mortality_rate
ORDER BY entity, year;




                                                      
                                                       




















