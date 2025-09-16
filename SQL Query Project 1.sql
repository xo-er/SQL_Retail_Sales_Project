-- SQL Reatil Sales Analysis (Project 1)
create database Sql_Project_1;
use Sql_Project_1;
-- Create Table
create table retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FlOAT,	
	cogs FLOAT,
	total_sale FLOAT
    );

select * from retail_sales;
select count(*) from retail_sales;

-- Data Cleaning
select * from retail_sales
where age = 0 or price_per_unit = 0 or cogs = 0 or total_sale = 0;
delete from retail_sales where age = 0 or price_per_unit = 0 or cogs = 0 or total_sale = 0;

-- Data Exploration
-- How many sales we have?
select COUNT(*) as total_sale from retail_sales;

-- How many unique customers do we have?
select COUNT(DISTINCT customer_id) as total_sales from retail_sales;

-- What unique categories do we have?
select DISTINCT category from retail_sales;

-- Data Analysis & Business Key Problems
-- Q1. Write an SQL query to retireve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';

-- Q2. Write a SQL query to retieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select * from retail_sales where category = 'Clothing' AND quantity > 3 AND MONTH(sale_date) = 11 and YEAR(sale_date) = 2022;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category
select category, sum(total_sale) as net_sale from retail_sales group by category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) from retail_sales where category = "Beauty"; 

-- Q5. Write an SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(transactions_id) from retail_sales group by gender, category order by category;

-- Q7. Write an SQL query to calculate the average sale for each month. Find out the best selling month in each year.
select year, month, avg_sales 
from (select year(sale_date) as year, month(sale_date) as month, avg(total_sale) as avg_sales,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as Ranking
from retail_sales group by 1, 2) as t1 where Ranking = 1;

-- Q8. Write an SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) as total_sales from retail_sales group by customer_id order by total_sales desc limit 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count( distinct customer_id) as unique_customers from retail_sales group by category;

-- Q10. Write an SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 and 17, Evening > 17)
with hourly_sales as (select *,
case
when hour(sale_time) <= 12 then "Morning"
when hour(sale_time) between 12 and 17 then "Afternoon"
else "Evening"
end as shift
from retail_sales)
select shift, count(*) as total_orders from hourly_sales group by shift;

-- End of Project