SELECT * FROM pj.va
LIMIT 10;

select count(*)from pj.va;
SELECT count(*)
FROM PJ.va
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    -- data cleaning
    delete from PJ.va
    WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    
    -- data exploration
    -- how many sales we have
    select count(*) as total_sales from pj.va;
    -- how many unique customer we have
    select distinct customer_id from pj.va ORDER BY customer_id ASC ;
    -- total unique customer we have
    select count(distinct customer_id)from pj.va;

-- Data analysis and business key problems & answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from pj.va
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT *
FROM PJ.va
WHERE category = 'Clothing'
  AND quantiy >=4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  order by customer_id ASC;
  
  
  -- Q.3 Write a SQL query to calculate the total sales (total sale) for each category.
  
  select category ,
  sum(total_sale) as total_sales,
  count(*) as counts
  from pj.va
  group by 1;
  
  -- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age 
from pj.va
where category ='Beauty';
  
-- Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000.
select * from pj.va
where total_sale>1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender , category,count(transactions_id) as tot_transaction
 from pj.va
 group by
 gender,category
 order by 1;
 
 
 -- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year,month,avg_sal
from(
select year(sale_date)as year,
month(sale_date) as month,
round(avg(total_sale)) as avg_sal,
rank() over(partition by year(sale_date) order by round(avg(total_sale),2)desc) as rnk
from pj.va
group by 1,2) t2
where rnk=1
order by year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,
sum(total_sale) as tot_sale
from pj.va
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct(customer_id)) as unique_cust,
category from pj.va
group by 2;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


with hourly_sales as(
select * , case
when hour(sale_time)< 12
then
'MORNING'
when hour(sale_time)between 12 and 17
then 'AFTERNOON'
else
'EVENING'
end as shift
from pj.va )

select shift,count(*)as tot_orders from hourly_sales
group by SHIFT;