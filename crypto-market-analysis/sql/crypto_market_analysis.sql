create database crypto_analysis;


use crypto_analysis;

create table crypto_market(
	name varchar(100),
	symbol varchar(100),
	current_price float,
	market_cap bigint,
	market_cap_rank int,
	total_volume bigint,
	price_change_percentage_24h float,
	circulating_supply float,
	ath float,
	atl float,
	price_distance_from_ath float,
	price_distance_from_atl float,
	volatility_estimate float
);




-- ################## Phase 1 (warmup)##########################

-- selecting the table to check if evey thing is ok  
select *
from crypto_market
limit 10;


#Top 10 Coins by Market Cap

select name, market_cap
from crypto_market
order by market_cap desc
limit 10;

-- Show first 10 rows
select *
from crypto_market
limit 10;

-- Selecting only important columns
select name, symbol, current_price
from crypto_market;

-- Coins with price above $100

select name, symbol, current_price
 from crypto_market
 where current_price > 100
 ;
 
 -- Coins ranked in Top 10
 
 select name, symbol, market_cap_rank
 from crypto_market
 where market_cap_rank <= 10;

-- ################## Phase 2 (Sorting)##########################


-- Highest market cap 

select name, market_cap
from crypto_market
order by market_cap desc;


-- Lowest price coins

select name, current_price
from crypto_market
order by current_price asc
limit 10;

-- ################## Phase 3 (Aggragations)##########################

select * from
crypto_market;

-- Average crypto price

select avg(current_price)
from crypto_market;

 -- Highest price coin

select max(current_price)
from crypto_market;

-- Total market volume

select sum(total_volume)
from crypto_market;

-- ################## Phase 4 (Group By)##########################

select * from
crypto_market;

-- Group coins by symbol and calculate average price.

select symbol, avg(current_price)
from crypto_market
group by symbol
;

-- TO check if they are not replicated through count(*)

Select symbol, count(*)
from crypto_market
group by symbol
;  

-- ################## Phase 5 (Having)##########################
select * from
crypto_market;

-- Coins with average price above 100:

select symbol, avg(current_price) as avg_price
from crypto_market
group by symbol
having avg_price > 100
;


-- ################## Phase 6 (Analyst Style Queries)##########################

select *
from crypto_market
;

-- Top 10 most volatile coins:

select name, volatility_estimate
from crypto_market
order by volatility_estimate desc
limit 10;

 -- Coins closest to ATH:
 
 select name, price_distance_from_ath
 from crypto_market
 order by price_distance_from_ath asc
 limit 10;
 
 
-- #########################SQL Challenge (Round 1)##############################

select * 
from crypto_market
;

-- Q1. Find the top 5 cryptocurrencies with the highest current price.

select name, current_price
from crypto_market
order by current_price desc
limit 5;


-- Q2. Show the top 10 coins with the largest market capitalization.

select name, market_cap
from crypto_market
order by market_cap desc
limit 10;

-- Q3. Calculate the average price of all cryptocurrencies in the dataset.

select avg(current_price) as average_price
from crypto_market
;

-- Q4. Find coins whose price is greater than the average price.


select name, current_price
from crypto_market
where current_price >(
	select avg(current_price)
    from crypto_market
);


-- Q5. Find the 5 coins with the highest volatility_estimate.

select name, volatility_estimate
from crypto_market
order by volatility_estimate desc
limit 5;


-- Q6. Find the top 10 coins closest to their ATH.

select name, ath, price_distance_from_ath
from crypto_market
order by price_distance_from_ath asc
limit 10;


 -- Q7. Calculate the total trading volume of all coins.
 
 select sum(total_volume)
 from crypto_market
 ;
 
 -- Q8. Find how many cryptocurrencies exist in your dataset.
 
 select  count(name)
 from crypto_market
 ;
 
 -- or
 
 select count(*) as total_coins
 from crypto_market
 ;
 
-- Q9. Find all coins whose 24h price change is greater than 10%
 
SELECT name, price_change_percentage_24h
FROM crypto_market
WHERE price_change_percentage_24h > 10;


-- Q10. Assign a rank based on market_cap (highest first).

select name, market_cap,
rank() over(order by market_cap) as market_rank
from crypto_market;

-- #########################SQL Challenge (Round 2)##############################

select *
from crypto_market;

-- Q1. Calculate the percentage of total market cap each coin represents.


select name, market_cap,
(market_cap /(select sum(market_cap) 
from crypto_market) * 100) as market_share_percent
from crypto_market
;


-- Q2. Return the top 3 coins with the highest volatility.

select name, volatility_estimate
from crypto_market
order by volatility_estimate desc 
limit 3;


-- Q3. Find coins whose volatility_estimate is greater than the average volatility.

select name, volatility_estimate
from crypto_market
where volatility_estimate > (
select avg(volatility_estimate)
from crypto_market
)
;

-- Q4. Create a ranking of coins based on current_price (highest first).

select name, current_price,
rank() over(order by current_price desc) as price_rank 
from crypto_market
;

-- Q5. Create a price category column

select name, current_price,
CASE
	when current_price > 1000 then'High Price'
    when current_price between 100 and 1000 then 'Medium Price'
    else 'Low Price'
    end as price_category
from crypto_market
;

-- #########################SQL Challenge (Round 3)##############################

-- Q1. Rank coins by market_cap, and also show their percentage share of total market cap.

select name, market_cap,
rank() over(order by market_cap desc) as market_rank,
(market_cap / (select sum(market_cap) from crypto_market) * 100) as market_share_percent
from crypto_market
;

-- Q2. Return the 5 cheapest coins based on current_price.

select name, current_price
from crypto_market
order by current_price asc
limit 5;


-- Q3. Find coins whose market_cap is greater than the average market cap.

SELECT name, market_cap
FROM crypto_market
WHERE market_cap > (
    SELECT AVG(market_cap)
    FROM crypto_market
);

-- Q4. Using the price categories from before, rank coins within each category by current_price.

SELECT 
    name,
    current_price,
    CASE
        WHEN current_price > 1000 THEN 'High Price'
        WHEN current_price BETWEEN 100 AND 1000 THEN 'Medium Price'
        ELSE 'Low Price'
    END AS price_category,
    RANK() OVER (
        PARTITION BY
            CASE
                WHEN current_price > 1000 THEN 'High Price'
                WHEN current_price BETWEEN 100 AND 1000 THEN 'Medium Price'
                ELSE 'Low Price'
            END
        ORDER BY current_price DESC
    ) AS category_rank
FROM crypto_market;

-- Q5. Create a column called volatility_level with rules:

select name, volatility_estimate,
case
	when volatility_estimate >5000 then 'Extreme'
    when volatility_estimate between 1000 and 5000 then 'High'
    when volatility_estimate between 100 and 1000 then 'Moderate'
    else 'Low'
    end as volatility_level
from crypto_market;


 
