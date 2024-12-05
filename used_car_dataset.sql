 --What is the distribution of cars based on their age? 
 --How many cars fall into each age group?
 
SELECT (2024 - year_made) as car_age,
count(*) as car_count
from used_car_dataset
GROUP by car_age
ORDER by car_age;

--Popular Car Models:
--Which car models are the most popular in the dataset?
--How many of each model are there?
SELECT model, COUNT(*) OVER(PARTITION BY model) as model_count
from used_car_dataset
ORDER by model_count DESC;

SELECT model, count(*) as model_count
FROM used_car_dataset
GROUP by model
ORDER by model_count DESC;

--3.Fuel Efficiency Comparison:
--Compare the fuel efficiency of different car models.
--Which models have the best and worst mileage?

SELECT model, avg_fuel_consumption
FROM 
	(SELECT model, AVG(kmdriven) as avg_fuel_consumption FROM used_car_dataset
	GROUP by model  
	) as avg_consumption
    WHERE avg_fuel_consumption = (SELECT MAX(AVG(kmdriven)) from used_car_dataset GROUP by model)
    or avg_fuel_consumption = (SELECT  MIN(AVG(kmdriven)) from used_car_dataset GROUP by model)
    ;

SELECT model, avg_mileage
from (
	SELECT model, AVG(kmdriven) as avg_mileage from used_car_dataset GROUP by model
)as avg_fuel

where  avg_mileage = (SELECT MAX(AVG(kmdriven)) from used_car_dataset GROUP by model)
OR  avg_mileage = (SELECT MIN(AVG(kmdriven)) from used_car_dataset GROUP by model);
    
--How many cars in the dataset have manual vs. automatic transmissions? 
--What percentage of each transmission type is represented?
---select Grade, count(*) * 100.0 / (select count(*) from demo)

SELECT transmission, COUNT(model)  * 100.0 /(select count(*) from used_car_dataset) as per_trasmission 
from used_car_dataset
GROUP by transmission 
order by per_trasmission;

-- Identify the top-selling years for cars in the dataset. 
--How many cars were sold in those years?

SELECT year_made, count(*) car_sold
from used_car_dataset
GROUP by year_made
ORDER by year_made DESC;

--What is the distribution of cars based on fuel type? 
--How many cars use gasoline, diesel, or other fuel types?

SELECT fueltype , count(*) as sum_Of_fueltype
from used_car_dataset
GROUP by fueltype 
ORDER by fueltype;







