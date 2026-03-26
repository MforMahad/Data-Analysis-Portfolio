create database retail_sales;

use retail_sales;


create table retail_sales_table(
	transaction_id varchar(20),
    item varchar(50),
    quantity int,
    price_per_unit decimal(10,2),
    total_spent decimal(10,2),
    payment_method varchar(20),
    location varchar(20),
    transaction_date date,
    transaction_month varchar(10),
    transaction_year varchar(10)

);


-- counting the row to check that all the data is imported
select count(*)
from retail_sales_table;


-- checking the data

select *
from retail_sales_table
limit 20;


-- checking the date column where there were empty columns in the dataset that what happend to those

select transaction_date
from retail_sales_table
limit 20;

-- so after checking transaction _date column the rows which were empty sql changed them to '0000-00-00'

-- counting them to check how many are those
 
select count(*) as empty_dates
from retail_sales_table
where transaction_date = '0000-00-00';

-- As there are 457 rows so have to change them to null

update retail_sales_table
set transaction_date = null
where transaction_date = '0000-00-00';

-- counting the same rows

select *
from retail_sales_table
limit 20;

-- now modifying the transaction_year column to int as its in varchar in the table

alter table retail_sales_table
modify transaction_year int;


-- when transaction_year column when changed to int the unknown rows changed to 0 because they were string
select transaction_year
from retail_sales_table
limit 20;

select count(*)
from retail_sales_table
where transaction_year = '0'
;

-- removing 0's from the column

update retail_sales_table
set transaction_year = null
where transaction_year = '0'
;


 -- Quich Sanity Check
 select count(*)
 from retail_sales_table;
 
 
 -- First I will  recreate your Excel insights using SQL(EDA)
 -- 1. Total Revenue
 
 select sum(total_spent) as total_revenue
 from retail_sales_table;
 
 
 -- 2. Revenue by Item (Top Products)
 
select  item,sum(total_spent) as revenue_by_item
from retail_sales_table
group by item
order by revenue_by_item desc;

-- 3. Monthly Sales Trend

select transaction_month, sum(total_spent) as revenue_by_month
from  retail_sales_table
group by transaction_month
order by revenue_by_month desc;

-- 4. Payment Method Analysis

select payment_method, sum(total_spent) as top_payment_method
from retail_sales_table
group by payment_method
order by top_payment_method desc;

-- Location Analysis

select location, sum(total_spent) as top_revenue_by_location
from retail_sales_table
group by location
order by top_revenue_by_location desc; 


-- Advanced SQL EDA of retail sales table

select *
from retail_sales_table
limit 10;

-- 1. Average Order Value (AOV)
-- Q. “How much does a customer spend per transaction?”

select
	round(sum(total_spent) / count(distinct transaction_id), 2) as avg_order_value
from retail_sales_table;

-- 2. Total Transactions

select count(distinct transaction_id) as total_transactions
from retail_sales_table;

-- 3. Top 3 Products by Revenue

select item, sum(total_spent) as revenue
from retail_sales_table
group by item
order by revenue
limit 3;

-- 4. Most Popular Item (by quantity sold)

select item, sum(quantity) as total_quantity
from retail_sales_table
group by item
order by total_quantity desc
limit 1;

-- 5. Monthly Growth Trend 
-- Q. Compare month-to-month performance

select transaction_month, sum(total_spent) as revenue,
lag(sum(total_spent)) over(order by transaction_month) as prev_month,
sum(total_spent) - lag(sum(total_spent)) over(order by transaction_month) as growth
from retail_sales_table
group by transaction_month
order by transaction_month;


-- 6. Revenue Contribution % by Item
-- Q. Which product contributes how much?

select item, sum(total_spent) revenue,
round(100 * sum(total_spent) / (select sum(total_spent) from retail_sales_table), 2) as item_contribution
from retail_Sales_table
group by item
order by revenue desc;

-- 7. Payment Method Share %
select payment_method, sum(total_spent) as revenue,
round(100 * sum(total_spent)/ (select sum(total_spent) from retail_sales_table), 2) as percentage
from retail_sales_table
group by payment_method
order by revenue desc;


-- 8. In-store vs Takeaway (Clean View) - (removed unknown location  so that we can see clearly that if instore revenue is more then takeaway )
select location, sum(total_spent) revenue
from retail_sales_table
where location != 'unknown'
group by location
order by revenue desc;



-- Transform your dataset into multiple tables(For practice only)

-- creating items table

create table items as
select distinct item as item_name
from retail_sales_table;

Alter table items
add item_id int auto_increment primary key;

select *
from items;

-- creating payment table

create table payment_method as
select distinct payment_method
from retail_Sales_table;


alter table payment_method
add payment_id int auto_increment primary key;


-- creating location_table

create table location as
select distinct location 
from retail_sales_table;

alter table location
add location_id int auto_increment primary key;

-- Modifying Main Table 

ALTER TABLE retail_sales_table
ADD item_id INT,
ADD payment_id INT,
ADD location_id INT;

-- updating item id

update retail_sales_table as r
join items as i on r.item = i.item_name
set r.item_id = i.item_id;

-- Modify Main Table (BIG STEP)

update retail_sales_table as r
join payment_method as p
on r.payment_method = p.payment_method
set r.payment_id = p.payment_id;

-- Update location_id

update retail_sales_table as r
join location as l 
on r.location = l.location
set r.location_id = l.location_id;

select * from retail_sales_table
limit 20;


-- Just doing some practice of joins and and Doing same Analysis etc

-- Revenue by Item (using JOIN)

select i.item_name, sum(r.total_spent) as revenue
from retail_sales_table as r
join items as i on r.item_id = i.item_id
group by i.item_name
order by revenue desc;

-- Payment Method Analysis (JOIN)

select p.payment_method, sum(r.total_spent) as revenue
from retail_sales_table as r
join payment_method as p on r.payment_id = p.payment_id
group by p.payment_method
order by revenue desc;

-- Location Analysis (JOIN)
select l.location, sum(r.total_spent) as revenue
from retail_sales_table as r
join location as l on r.location_id = l.location_id
group by l.location
order by revenue desc;