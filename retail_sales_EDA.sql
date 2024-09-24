select * from retail_sales_copy;

-- 1. write a SQL query to find the total sales per year 
select year(sale_date) as year, count(total_sale) 
from retail_sales_copy
group by `year`; 

-- 2. what are the different types of categories present in the data
select distinct category from retail_sales_copy;

-- 3. Write a SQL query to find the total sales made in each category
with categorical_sales as (
select *,
sum(total_sale) over(partition by category) as 'total_categorical_sales'
from retail_sales_copy
) select distinct category, total_categorical_sales 
from categorical_sales;

-- 4. Write a SQL query to find all transactions where category id 'clothing' with highest quantity sold
SELECT category, MAX(quantiy), SUM(total_sale) AS total_sale
FROM retail_sales_copy
WHERE category = 'Clothing'
GROUP BY category;

-- 5.  Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. 
select category, avg(age) as 'Average age' 
from retail_sales_copy
where category = 'Beauty';

-- 6. Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales_copy
where total_sale > 1000;

-- 7. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category. 
select gender, category, count(*) as 'total_tranaction'
from retail_sales_copy
group by category, gender
order by 1;

-- 8. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
select `year`, `month`, avg_sale
from (
	select extract(year from sale_date) as 'year',
		   extract(month from sale_date) as 'month',
           round(avg(total_sale),2) as 'avg_sale',
           rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as `rank`
	from retail_sales_copy
    group by 1,2
) as t1
where `rank` = 1;

-- 9. Write a SQL query to find the top five customers based on  the highest total sales
select customer_id, sum(total_sale) as 'total_sales' 
from retail_sales_copy
group by customer_id
order by sum(total_sale) desc
limit 5;

-- 10. Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as 'unique_customer_id'
from retail_sales_copy
group by category;

-- 11. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale as (
	select *,
    case
		when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
        end as shifts
	from retail_sales_copy
) select shifts, count(*) as 'total_orders'
from hourly_sale
group by shifts;