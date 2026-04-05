create database ecommerce_dataset;

use ecommerce_dataset;

create table orders (
	order_id int,
    customer_id int,
    order_date datetime,
	product_category varchar(20),
    order_value decimal(10, 2),
    payment_method varchar(20),
    delivered int
);


create table customers(
	customer_id int,
    gender varchar(10),
    age int,
    city varchar(20),
    loyalty_score decimal(10, 2)
);

create table products (
	product_id int,
    product_name varchar(20),
    category varchar(20),
    price decimal(10, 2),
    stock int
);

create table reviews(
	review_id int,
    customer_id int,
    product_id int,
    rating int,
    review_text varchar(100)
    
);


select * 
from reviews
limit 5;

# 1️⃣ Orders + Customers

#Who is generating revenue and of which cities they belong?

select c.customer_id, 
		c.city, 
		sum(o.order_value) as total_spent
from customers as c
join orders as o on c.customer_id = o.customer_id
group by customer_id, city
order by total_spent desc;


#2. Revenue by City

select 
	c.city, 
    sum(o.order_value) as revenue
from customers as c
join orders as o on c.customer_id = o.customer_id
group by c.city
order by revenue desc;

# 3.Revenue by Category

select product_category, sum(order_value) as revenue
from orders
group by product_category
order by revenue desc;


# Top Customers

select c.customer_id, c.loyalty_score, sum(o.order_value) as total_spent
from customers as c
join orders as o on c.customer_id = o.customer_id
group by c.customer_id, c.loyalty_score
order by total_spent desc;

# Average Order Value per Customer

select 
	c.customer_id,
	round(avg(o.order_value), 2) as avg_order
from customers as c
join orders as o on c.customer_id = o.customer_id
group by c.customer_id;

# Average Rating per Product

select 
	p.product_name,
	round(avg(r.rating), 2) as avg_rating
from products as p
join reviews as r on p.product_id = r.product_id
group by p.product_name
order by avg_rating desc;

# Category Performance (Ratings)

select 
		p.category,	
		round(avg(r.rating), 2) as category_performance
from products as p
join reviews as r on p.product_id = r.product_id
group by p.category
order by category_performance desc;


# Customer Segmentation

select 
	customer_id,
	sum(order_value) as total_spent,
case
	when sum(order_value) > 500 then "High Value"
    when sum(order_value) > 200 then "Medium Value"
    else "Low Value"
end as customer_segment
from orders
group by customer_id;


# Monthly Revenue Trend


select 
	month(order_date) as monthly,
	sum(order_value) as revenue
from orders
group by monthly
order by monthly;