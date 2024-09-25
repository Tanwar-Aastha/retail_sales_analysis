# Retail Sales Analysis
## **Dataset Description: Retail Sales**
This dataset contains retail sales transactions and was used to analyze sales performance and customer behavior. The dataset includes the following columns:

**1. transaction_id:** Unique identifier for each transaction.<br>
**2. sale_date:** Date when the sale occurred.<br>
**3. sale_time:** Time when the sale occurred.<br>
**4. customer_id:** Unique identifier for the customer.<br>
**5. gender:** Gender of the customer (e.g., male, female).<br>
**6. age:** Age of the customer.<br>
**7. category:** Product category of the purchased item.<br>
**8. quantity:** Number of units sold in each transaction.<br>
**9. price_per_unit:** Price of a single unit of the product.<br>
**10. COGS:** Cost of goods sold for each transaction.<br>
**11. total_sale:** Total sale value, calculated as quantity * price_per_unit.<br>

This dataset was used to perform a retail sales analysis using MySQL to derive insights into sales trends, customer demographics, and product categories.
<br>

## Objectives

1. **Data Cleaning**: Identify and remove any records with missing or null values.
2. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
3. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Data Exploration and Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Standarization**: Correcting the column names and their datatypes.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select count(*) from retail_sales_copy;

alter table retail_sales_copy
rename column ï»¿transactions_id to transaction_id;

alter table retail_sales_copy
modify column sale_date date;

alter table retail_sales_copy
modify column sale_time time; 

alter table retail_sales_copy
modify column transaction_id int primary key,
modify column gender varchar(10),
modify column category varchar(35),
modify column price_per_unit float,
modify column cogs float,
modify column total_sale float;

select * from retail_sales_copy
where
    sale_date is null or sale_time is null or customer_id is null or 
    gender is null or age is null or category is null or 
    quantiy is null or price_per_unit is null or cogs is null;

delete from retail_sales_copy
where
    sale_date is null or sale_time is null or customer_id is null or 
    gender is null or age is null or category is null or 
    quantiy is null or price_per_unit is null or cogs IS NULL;
```

### Data Analysis & Finding

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to find the total sales per year**
```sql
select year(sale_date) as year, count(total_sale) 
from retail_sales_copy
group by `year`; 
```

2. **Write a SQL query to retrieve different types of categories present in the data**
```sql
select distinct category from retail_sales_copy;
```
3. **Write a SQL query to find the total sales made in each category**
```sql
with categorical_sales as (
select *,
sum(total_sale) over(partition by category) as 'total_categorical_sales'
from retail_sales_copy
) select distinct category, total_categorical_sales 
from categorical_sales;
```
4. **Write a SQL query to find all transactions where category id 'clothing' with highest quantity sold.**
```sql
select category, max(quantiy), sum(total_sale) as total_sale
from retail_sales_copy
where category = 'Clothing'
group by category;
```
5. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**
```sql
select category, avg(age) as 'Average age' 
from retail_sales_copy
where category = 'Beauty';
```
6. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**
```sql
select *
from retail_sales_copy
where total_sale > 1000;
```
7. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**
```sql
select gender, category, count(*) as 'total_tranaction'
from retail_sales_copy
group by category, gender
order by 1;
```
8. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**
```sql
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
```
9. **Write a SQL query to find the top five customers based on  the highest total sales.**
```sql
select customer_id, sum(total_sale) as 'total_sales' 
from retail_sales_copy
group by customer_id
order by sum(total_sale) desc
limit 5;
```
10. **Write a SQL query to find the number of unique customers who purchased items from each category.**
```sql
select category, count(distinct customer_id) as 'unique_customer_id'
from retail_sales_copy
group by category;
```
11. **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)**
```sql
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
```
