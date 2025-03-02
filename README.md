# Retail Trends and Performance Analysis

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
2. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset along with the key trends and patterns in the data.
3. **Business Analysis**: Use SQL to answer specific business questions related to sales trends, customer demographics, and product categories.

## Executive Summary

The analysis revealed key insights into sales performance and customer behavior:

- Peak Sales Periods: Sales peaked during September to December, with the highest transactions recorded in December (55K) and September (50K+).
- Customer Behavior: Identified high-value customers, with top contributors generating up to 38K in revenue.
- Category Insights: Clothing and Beauty remained consistently popular, with Clothing leading in total sales (1,780) and Beauty in average sale price.
- High-Value Transactions: The average order value is 457.09, with total revenue reaching 908K; peak sales occurred in December (55K) and September (50K+), indicating strong seasonal demand.
Strategic Insights: These trends highlight opportunities for upselling, premium product marketing, and optimizing inventory for peak seasons to maximize profitability.

## Detailed Results

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

### Key Business Insights

The following SQL queries were developed to answer specific business questions:

1. **Total sales per year**
```sql
select year(sale_date) as year, count(total_sale) 
from retail_sales_copy
group by `year`; 
```

2. **Popular Product Categories**
```sql
select distinct category from retail_sales_copy;
```
3. **Total sales made in each category**
```sql
with categorical_sales as (
select *,
sum(total_sale) over(partition by category) as 'total_categorical_sales'
from retail_sales_copy
) select distinct category, total_categorical_sales 
from categorical_sales;
```
4. **Top Transactions in 'Clothing' Category**
```sql
select category, max(quantiy), sum(total_sale) as total_sale
from retail_sales_copy
where category = 'Clothing'
group by category;
```
5. **Customer Demographics by Category**
```sql
select category, avg(age) as 'Average age' 
from retail_sales_copy
where category = 'Beauty';
```
6. **High-Value Transactions**
```sql
select *
from retail_sales_copy
where total_sale > 1000;
```
7. **Total number of transactions (transaction_id) made by each gender in each category.**
```sql
select gender, category, count(*) as 'total_tranaction'
from retail_sales_copy
group by category, gender
order by 1;
```
![image](https://github.com/user-attachments/assets/fe4676af-5c80-4097-8c0d-9e7ba009ab94)

Males preferred Clothing and Electronics, showing higher transaction counts in these categories i.e 351 and 343. Whereas, females showed a strong preference for Beauty products, as they had more transactions (330) in this category compared to males (281).

8. **Monthly Sales Trends**
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
9. **Top-Spending Customers**
```sql
select customer_id, sum(total_sale) as 'total_sales' 
from retail_sales_copy
group by customer_id
order by sum(total_sale) desc
limit 5;
```
10. **Unique customers who purchased items from each category.**
```sql
select category, count(distinct customer_id) as 'unique_customer_id'
from retail_sales_copy
group by category;
```
11. **Shift-Wise Sales Analysis**
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
## Findings

- **Customer Demographics:** The dataset captures a diverse range of customer age groups, with sales spanning multiple categories, including Clothing and Beauty.
- **High-Value Transactions:** A notable number of transactions exceed a total sale amount of 1000, indicating a trend of premium or high-value purchases.
- **Sales Trends:** A monthly sales analysis reveals fluctuations in sales, helping to identify peak periods of high demand.
- **Customer Insights:** The analysis highlights the top-spending customers and the most popular product categories, offering valuable insights into customer preferences.

## Observations

- Peak Sales Periods: Seasonal patterns and specific months contributed to spikes in sales.
- Customer Preferences: Categories like Clothing and Beauty had consistent demand across demographics.
- Premium Transactions: A notable proportion of transactions were high-value purchases.
- Sales Shifts: Sales activity varied significantly across shifts.

## Recommendations
- Inventory Optimization: Increase stock levels for high-demand months and popular categories.
- Targeted Marketing: Use demographic insights to tailor marketing strategies for specific age groups and categories.
- Upselling Opportunities: Leverage high-value transaction data to promote premium product bundles.
- Shift Planning: Optimize staffing and promotions during peak shifts to improve customer experience.

