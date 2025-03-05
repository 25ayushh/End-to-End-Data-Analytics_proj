create database python_retailer_jyp_nb;

use python_retailer_jyp_nb;

select * from retailer_data limit 2;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retailer_data' ;


-- Create view for top 10 highest revenue generating products
CREATE VIEW top_10_highest_revenue_products AS
SELECT product_id, ROUND(SUM(sale_price), 2) AS sales
FROM retailer_data
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

-- Create view for top 5 highest selling products in each region
CREATE VIEW top_5_highest_selling_products_each_region AS
SELECT region, product_id, ROUND(SUM(sale_price), 2) AS sales
FROM retailer_data
GROUP BY region, product_id
ORDER BY sales DESC
LIMIT 10;

-- Create view for month over month growth comparison for 2022 and 2023 sales
CREATE VIEW month_over_month_growth_2022_2023 AS
WITH sales_by_month AS (
    SELECT 
        MONTH(order_date) AS month,
        YEAR(order_date) AS year,
        SUM(sale_price) AS total_sales
    FROM retailer_data
    WHERE YEAR(order_date) IN (2022, 2023)
    GROUP BY month, year
)
SELECT 
    s2022.month,
    s2022.total_sales AS sales_2022,
    s2023.total_sales AS sales_2023,
    ((s2023.total_sales - s2022.total_sales) / NULLIF(s2022.total_sales, 0)) * 100 AS growth_percentage
FROM sales_by_month s2022
LEFT JOIN sales_by_month s2023
ON s2022.month = s2023.month
AND s2022.year = 2022
AND s2023.year = 2023
ORDER BY s2022.month;

-- Create view for highest sales month in each category
CREATE VIEW highest_sales_month_each_category AS
SELECT category,
       MONTHNAME(order_date) AS month,
       MONTH(order_date) AS monthref,
       YEAR(order_date),
       ROUND(SUM(sale_price), 2) AS sales
FROM retailer_data
GROUP BY category, month, monthref, YEAR(order_date)
ORDER BY monthref ASC, YEAR(order_date) ASC, sales DESC
LIMIT 100;

-- Create view for sub-category with highest profit growth in 2023 compared to 2022
CREATE VIEW highest_profit_growth_subcategory_2023 AS
WITH profit_by_subcategory AS (
    SELECT 
        sub_category,
        YEAR(order_date) AS order_year,
        SUM(profit) AS total_profit
    FROM retailer_data
    WHERE YEAR(order_date) IN (2022, 2023)
    GROUP BY sub_category, order_year
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
    FROM profit_by_subcategory
    GROUP BY sub_category
) AS subcategory_profit_growth
ORDER BY growth_percentage DESC
LIMIT 1;
