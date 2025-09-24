# Sales Transaction Analysis – SQL Project

## Project Overview

This project demonstrates **SQL-based analysis** of a retail sales dataset. It covers **data cleaning, exploration, and business insights** using MySQL Workbench.

The dataset includes **transactions, customer info, product categories, quantities, and sales amounts**.

## Database & Table Setup

```sql
CREATE DATABASE PJ;
USE PJ;

CREATE TABLE VA (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

## Data Cleaning

**Check for NULL values:**

```sql
SELECT COUNT(*)
FROM PJ.va
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL;
```

**Remove NULL rows:**

```sql
DELETE FROM PJ.va
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL;
```

## Data Exploration

* Total transactions:

```sql
SELECT COUNT(*) AS total_sales FROM PJ.va;
```

* Total unique customers:

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM PJ.va;
```

## Business Queries – Key Examples

**Q1: Transactions on '2022-11-05'**

```sql
SELECT * FROM PJ.va
WHERE sale_date = '2022-11-05';
```

**Q2: Clothing transactions (>10 qty) in Nov-2022**

```sql
SELECT * FROM PJ.va
WHERE category='Clothing' AND quantiy>10
  AND DATE_FORMAT(sale_date,'%Y-%m')='2022-11';
```

**Q3: Total sales per category**

```sql
SELECT category, SUM(total_sale) AS total_sales
FROM PJ.va
GROUP BY category;
```

**Q4: Average age of Beauty customers**

```sql
SELECT ROUND(AVG(age),2) AS avg_age
FROM PJ.va
WHERE category='Beauty';
```

**Q5: Transactions with total\_sale > 1000**

```sql
SELECT * FROM PJ.va
WHERE total_sale>1000;
```

**Q6: Total transactions by gender & category**

```sql
SELECT gender, category, COUNT(transactions_id) AS tot_transaction
FROM PJ.va
GROUP BY gender, category;
```

**Q7: Best selling month per year**

```sql
SELECT year, month, avg_sal
FROM (
    SELECT YEAR(sale_date) AS year,
           MONTH(sale_date) AS month,
           ROUND(AVG(total_sale)) AS avg_sal,
           RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS rnk
    FROM PJ.va
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t2
WHERE rnk=1;
```

**Q8: Top 5 customers by total sales**

```sql
SELECT customer_id, SUM(total_sale) AS tot_sale
FROM PJ.va
GROUP BY customer_id
ORDER BY tot_sale DESC
LIMIT 5;
```

**Q9: Unique customers per category**

```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_cust
FROM PJ.va
GROUP BY category;
```

**Q10: Orders by shift (Morning/Afternoon/Evening)**

```sql
WITH hourly_sales AS (
    SELECT *,
           CASE
               WHEN HOUR(sale_time)<12 THEN 'MORNING'
               WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
               ELSE 'EVENING'
           END AS shift
    FROM PJ.va
)
SELECT shift, COUNT(*) AS tot_orders
FROM hourly_sales
GROUP BY shift;
```

## Key Findings

* **Clothing transactions** often have smaller quantities, while **Electronics** and **Beauty** have higher-value sales.
* **Afternoon shift** records the most transactions.
* Top customers contribute a significant portion of total sales.
* Average customer age in Beauty category provides insight for marketing strategies.
