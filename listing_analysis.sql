--What is the average price of properties by property type 
--(e.g., Entire home/apt, Private room, Shared room)?

select property_type,room_type, ROUND(AVG(price), 3) as avg_prop_type 
from listings
GROUP by property_type
ORDER by property_type DESC
limit 10;


--Top 5 Hosts by Response Rate
--
SELECT host_name, host_response_rate
from listings
ORDER by  host_response_rate DESC lIMIt 5;

--What is the average rating of properties by neighborhood?
SELECT neighbourhood_cleansed, ROUND(AVG(review_scores_rating),4) as Avg_rating
from listings
GROUP by neighbourhood_cleansed
order by neighbourhood_cleansed LIMIT 10;

--Number of Properties by Superhost Status
SELECT COUNT(*) as num_of_prop, host_is_superhost
from listings
GROUP by host_is_superhost;

--Average Price by Accommodates:
SELECT accommodates, ROUND(AVG(price),4)as avg_price  FROM listings GROUP BY accommodates;


--Average Price by Accommodates:
SELECT neighbourhood_cleansed, COUNT(*) as num_listings FROM listings 
GROUP BY neighbourhood_cleansed 
ORDER BY num_listings DESC LIMIT 3;

--What is the average response time of hosts by their response rate?demo
SELECT  host_response_rate, AVG(host_response_time) as avg_restime
from listings
where host_response_rate >= 0.95
GROUP by host_response_rate;

---How many reviews have been received by properties of each type
--select by max?
SELECT room_type, COUNT(*) as reviews_count 
from listings
GROUP by room_type 
order by reviews_count DESC;


--Average Price by Bedrooms
--since we cannot bedroom without beds, no sense unless otherswise kitchen, sitting room
SELECT beds, bedrooms, ROUND(AVG(price),4) as avg_bedroom_price
from listings
GROUP BY bedrooms
HAVING beds > 0 and bedrooms > 0;

--Top five host by  number of reviewsdemo
SELECT  host_name, number_of_reviews from listings 
order by number_of_reviews DESC LIMIT 5;

--Comprehensive Real_World problemo

---Identifying Overpriced Properties:
--Which properties are overpriced compared to their average price by property type

WITH overall_avg_price as (
  SELECT property_type, AVG(price) as overall_avg_price
from listings
where overall_avg_price IS NOT NULL
),
avg_price_per_type AS (
  SELECT property_type, AVG(price) as avg_price_per_prop
  from listings 
  where  avg_price_per_prop IS NOT NULL
  GROUP by property_type
)
SELECT 
	property_type, overall_avg_price, avg_price_per_prop, 
  	CASE 
		WHEN avg_price_per_prop  >  overall_avg_price THEN 'Overpriced'
    	ELSE 'Stable'
	END AS trend
FROM
overall_avg_price;





---Host Performance Analysis:
--How do hosts with high response rates perform in terms of average rating 
--and number of reviews?
WITH high_response_hosts AS (
    SELECT 
        host_id, 
        host_response_rate,  
        number_of_reviews
    FROM 
        listings
    WHERE 
        host_response_rate >= 0.90 -- Assuming high response rate is 90% or above
)
SELECT 
    AVG(number_of_reviews) AS avg_reviews_high_response
FROM 
    high_response_hosts;
