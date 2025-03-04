**# Python-Retailer-Data-Analysis

## Overview**
This project is an end-to-end data analysis project utilizing a retailer dataset. The dataset is cleaned using Python, and various SQL queries are created in MySQL to analyze the data and derive meaningful insights.

**## Table of Contents**
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)
- [Queries](#queries)
- [Results](#results)


**## Data Cleaning**
The data cleaning process was conducted using Python, involving steps such as:
- Removing missing values
- Handling duplicates
- Normalizing data formats
- Standardizing column names

**## Data Analysis**
The analysis involves writing and executing several MySQL queries to gain insights from the cleaned data.

**## Queries
### Database Setup**
sql
CREATE DATABASE python_retailer_jyp_nb;
USE python_retailer_jyp_nb;
SELECT * FROM retailer_data LIMIT 2;

**Schema Information**
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'retailer_data';

**Top 10 Highest Revenue Generating Products**
SELECT product_id, ROUND(SUM(sale_price), 2) AS sales
FROM retailer_data
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;





![image](https://github.com/user-attachments/assets/1394d2df-7e68-427c-9fb2-25e6147c7b5f)






**find top 5 highest selling products in each region **
select 
region,
product_id,
round(sum(sale_price),2) as sales
from 
retailer_data
group by 
region,product_id
order by sales DESC
limit 10;






![image](https://github.com/user-attachments/assets/4a9bdac6-630b-44a8-aaf3-f41a06ca5beb)







**find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023 **
WITH sales_by_month AS (
SELECT 
MONTH(order_date) AS month,
YEAR(order_date) AS year,
SUM(sale_price) AS total_sales
FROM 
retailer_data
WHERE 
YEAR(order_date) IN (2022, 2023)
GROUP BY 
month, year
)
SELECT 
s2022.month,
s2022.total_sales AS sales_2022,
s2023.total_sales AS sales_2023,
((s2023.total_sales - s2022.total_sales) / NULLIF(s2022.total_sales, 0)) * 100 AS growth_percentage
FROM 
sales_by_month s2022
LEFT JOIN 
sales_by_month s2023
ON 
s2022.month = s2023.month
AND 
s2022.year = 2022
AND 
s2023.year = 2023
ORDER BY 
s2022.month;





![image](https://github.com/user-attachments/assets/d30bf550-f2ca-442b-b40f-9e18da00e02d)

**for each category which month had highest sales**
SELECT category,
MONTHNAME(order_date) AS month,
MONTH(order_date) AS monthref,
year(order_date),
ROUND(SUM(sale_price), 2) AS sales
FROM retailer_data
GROUP BY category, month, monthref, year(order_date)
ORDER BY monthref ASC,year(order_date) ASC, sales DESC
limit 100
;





![image](https://github.com/user-attachments/assets/1c9353ae-2c13-4e17-a61d-18ed7ec4672f)
![image](https://github.com/user-attachments/assets/66785745-c708-4eb5-83f4-6007ba366787)
![image](https://github.com/user-attachments/assets/a271b545-5e5f-4600-8ca4-a4e909b40a10)







**which sub category had highest growth by profit in 2023 compare to 2022**
WITH profit_by_subcategory AS (
SELECT 
sub_category,
YEAR(order_date) AS order_year,
SUM(profit) AS total_profit
FROM 
retailer_data
WHERE 
YEAR(order_date) IN (2022, 2023)
GROUP BY 
sub_category, order_year
)
SELECT 
sub_category,
total_profit_2023 - total_profit_2022 AS profit_growth,
((total_profit_2023 - total_profit_2022) / NULLIF(total_profit_2022, 0)) * 100 AS growth_percentage
FROM (
SELECT 
sub_category,
SUM(CASE WHEN order_year = 2022 THEN total_profit ELSE 0 END) AS total_profit_2022,
SUM(CASE WHEN order_year = 2023 THEN total_profit ELSE 0 END) AS total_profit_2023
FROM 
profit_by_subcategory
GROUP BY 
sub_category
) AS subcategory_profit_growth
ORDER BY 
growth_percentage DESC
LIMIT 1;




![image](https://github.com/user-attachments/assets/5009101b-4a8a-42cf-b16f-4f396b2e2d67)
