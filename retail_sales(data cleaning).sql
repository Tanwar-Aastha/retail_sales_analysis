SELECT * FROM project1.retail_sales;

-- Creating a copy of retail_sales
create table retail_sales_copy
like retail_sales;

-- inserting the data into the copy table
insert into retail_sales_copy
select * from retail_sales;

-- DATA CLEANING
/*=============== 3. Checking for duplicates ==================*/
select * from retail_sales_copy;
select count(*) from retail_sales_copy;
select distinct age from retail_sales_copy;


/*================= 2. Standardization ===========================*/
-- changing the name of the transaction_id column
alter table retail_sales_copy
rename column ï»¿transactions_id to transaction_id;

-- dealing with the sale_date column
alter table retail_sales_copy
modify column sale_date date;

-- dealing with the sale_time column
alter table retail_sales_copy
modify column sale_time time; 

alter table retail_sales_copy
modify column transaction_id int primary key,
modify column gender varchar(10),
modify column category varchar(35),
modify column price_per_unit float,
modify column cogs float,
modify column total_sale float;

select count(*) from retail_sales_copy;

select * from retail_sales_copy;

/*==================== 2.Checking for the null/missing values ===============*/
select * from retail_sales_copy
where
    sale_date is null or sale_time is null or customer_id is null or 
    gender is null or age is null or category is null or 
    quantiy is null or price_per_unit is null or cogs is null;
    
-- Deleting the rows having null values
delete from retail_sales_copy
where
    sale_date is null or sale_time is null or customer_id is null or 
    gender is null or age is null or category is null or 
    quantiy is null or price_per_unit is null or cogs IS NULL;