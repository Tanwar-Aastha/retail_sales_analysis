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
## Dashboard
[Power BI Dashboard](https://app.powerbi.com/groups/me/reports/649a0b69-eac5-40d7-9af5-53c165fef653/b59393d0e90c01b34ed6?experience=power-bi)

[Dashboard](./Retail_sales Dashboard.pdf)


## Findings

- Customer Demographics: Sales are distributed across various age groups, with significant contributions from both male and female customers.
- High-Value Transactions: A considerable number of transactions exceed $1,000, indicating strong demand for premium products.
- Sales Trends: Sales show steady growth throughout the year, with peak demand observed from September to December, reaching the highest in December (141K sales).
- Customer Insights: Electronics, Clothing, and Beauty are the top-selling categories, with Electronics and Clothing leading in gross sales.

## Observations

- Peak Sales Periods: September to December witnessed the highest revenue, with a sharp spike in September (129K sales) and consistent growth until December.
- Customer Preferences: Clothing and Beauty categories showed consistent demand across all age groups and genders.
- Premium Transactions: A notable proportion of transactions involved high-order values, with an average order value of $457.09.
- Sales Shifts: Sales activity peaks in the evening hours, particularly around 15:00 to 21:00, indicating a key time for promotions and engagement.

## Recommendations
- Inventory Optimization: Increase stock levels for peak months (September–December) and prioritize top-selling categories.
- Targeted Marketing: Leverage demographic insights to create personalized promotions for different age groups and preferences.
- Upselling Strategies: Introduce premium bundles and cross-selling tactics to capitalize on high-value purchase trends.
- Shift Planning: Align staffing, discounts, and marketing campaigns with peak shopping hours to maximize sales and customer satisfaction.

