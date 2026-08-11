-- ============================================================
-- WALMART SALES ANALYSIS
-- Author: Raj Kisley
-- Database: walmart_sales_analysis
-- Dataset: 1,000 Walmart sales transactions
-- ============================================================

-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS walmart_sales_analysis;
USE walmart_sales_analysis;

-- The CSV was imported into this table using MySQL Workbench's
-- Table Data Import Wizard.

-- Raw transaction table
CREATE TABLE IF NOT EXISTS walmart_sales (
    invoice_id VARCHAR(30),
    branch VARCHAR(5),
    city VARCHAR(50),
    customer_type VARCHAR(30),
    gender VARCHAR(10),
    product_line VARCHAR(100),
    unit_price DECIMAL(10,2),
    quantity INT,
    tax_5_percent DECIMAL(10,2),
    total DECIMAL(10,2),
    sale_date DATE,
    sale_time TIME,
    payment VARCHAR(30),
    cogs DECIMAL(10,2),
    gross_margin_percentage DECIMAL(10,2),
    gross_income DECIMAL(10,2),
    rating DECIMAL(3,1)
);

-- ============================================================
-- 2. DATA VALIDATION / CLEANING CHECKS
-- ============================================================

-- Total number of transactions
SELECT COUNT(*) AS total_rows
FROM walmart_sales;

-- Check for duplicate invoice IDs
SELECT invoice_id, COUNT(*) AS duplicate_count
FROM walmart_sales
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- Check for missing values in important fields
SELECT
    SUM(invoice_id IS NULL) AS missing_invoice_id,
    SUM(branch IS NULL) AS missing_branch,
    SUM(city IS NULL) AS missing_city,
    SUM(product_line IS NULL) AS missing_product_line,
    SUM(total IS NULL) AS missing_total,
    SUM(sale_date IS NULL) AS missing_date,
    SUM(sale_time IS NULL) AS missing_time
FROM walmart_sales;

-- ============================================================
-- 3. FEATURE ENGINEERING
-- ============================================================

DROP TABLE IF EXISTS walmart_sales_enriched;

CREATE TABLE walmart_sales_enriched AS
SELECT
    *,
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    MONTHNAME(sale_date) AS month_name,
    DAYNAME(sale_date) AS day_name,
    HOUR(sale_time) AS sale_hour,

    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) < 17 THEN 'Afternoon'
        WHEN HOUR(sale_time) < 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,

    CASE
        WHEN DAYOFWEEK(sale_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type

FROM walmart_sales;

-- Verify enriched data
SELECT *
FROM walmart_sales_enriched
LIMIT 5;

-- ============================================================
-- 4. OVERALL BUSINESS PERFORMANCE
-- ============================================================

-- 1. Overall business KPIs
SELECT
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(AVG(total), 2) AS avg_transaction_value,
    ROUND(SUM(gross_income), 2) AS total_gross_income,
    ROUND(AVG(rating), 2) AS avg_customer_rating
FROM walmart_sales_enriched;

-- ============================================================
-- 5. BRANCH ANALYSIS
-- ============================================================

-- 2. Branch-wise performance
SELECT
    branch,
    city,
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(SUM(gross_income), 2) AS gross_income,
    ROUND(AVG(total), 2) AS avg_transaction_value,
    ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_sales_enriched
GROUP BY branch, city
ORDER BY revenue DESC;

-- 3. Branch revenue contribution
SELECT
    branch,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(
        SUM(total) * 100 /
        (SELECT SUM(total) FROM walmart_sales_enriched),
        2
    ) AS revenue_percentage
FROM walmart_sales_enriched
GROUP BY branch
ORDER BY revenue DESC;

-- 4. Branch-wise product performance
SELECT
    branch,
    product_line,
    ROUND(SUM(total), 2) AS revenue,
    SUM(quantity) AS units_sold
FROM walmart_sales_enriched
GROUP BY branch, product_line
ORDER BY branch, revenue DESC;

-- ============================================================
-- 6. PRODUCT ANALYSIS
-- ============================================================

-- 5. Product-line revenue
SELECT
    product_line,
    ROUND(SUM(total), 2) AS total_revenue
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 6. Product-line gross income
SELECT
    product_line,
    ROUND(SUM(gross_income), 2) AS total_gross_income
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY total_gross_income DESC;

-- 7. Units sold by product line
SELECT
    product_line,
    SUM(quantity) AS units_sold
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY units_sold DESC;

-- 8. Average rating by product line
SELECT
    product_line,
    ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY avg_rating DESC;

-- 9. Average unit price by product line
SELECT
    product_line,
    ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY avg_unit_price DESC;

-- 10. Product lines generating above-average revenue
SELECT
    product_line,
    ROUND(SUM(total), 2) AS revenue
FROM walmart_sales_enriched
GROUP BY product_line
HAVING SUM(total) > (
    SELECT AVG(product_revenue)
    FROM (
        SELECT SUM(total) AS product_revenue
        FROM walmart_sales_enriched
        GROUP BY product_line
    ) AS product_summary
)
ORDER BY revenue DESC;

-- ============================================================
-- 7. CUSTOMER ANALYSIS
-- ============================================================

-- 11. Revenue by customer type
SELECT
    customer_type,
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(AVG(total), 2) AS avg_transaction_value
FROM walmart_sales_enriched
GROUP BY customer_type
ORDER BY revenue DESC;

-- 12. Revenue by gender
SELECT
    gender,
    COUNT(*) AS transactions,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(AVG(total), 2) AS avg_transaction_value
FROM walmart_sales_enriched
GROUP BY gender
ORDER BY revenue DESC;

-- 13. Payment method usage
SELECT
    payment,
    COUNT(*) AS transactions,
    ROUND(SUM(total), 2) AS revenue
FROM walmart_sales_enriched
GROUP BY payment
ORDER BY transactions DESC;

-- 14. Product preference by customer type
SELECT
    customer_type,
    product_line,
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold
FROM walmart_sales_enriched
GROUP BY customer_type, product_line
ORDER BY customer_type, units_sold DESC;

-- 15. Average rating by customer type
SELECT
    customer_type,
    ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_sales_enriched
GROUP BY customer_type
ORDER BY avg_rating DESC;

-- ============================================================
-- 8. TIME / SALES TREND ANALYSIS
-- ============================================================

-- 16. Monthly revenue trend
SELECT
    sale_month,
    month_name,
    ROUND(SUM(total), 2) AS total_revenue
FROM walmart_sales_enriched
GROUP BY sale_month, month_name
ORDER BY sale_month;

-- 17. Revenue by day of week
SELECT
    DAYOFWEEK(sale_date) AS day_number,
    day_name,
    ROUND(SUM(total), 2) AS revenue,
    COUNT(*) AS transactions
FROM walmart_sales_enriched
GROUP BY day_number, day_name
ORDER BY day_number;

-- 18. Revenue by time of day
SELECT
    time_of_day,
    COUNT(*) AS transactions,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(AVG(total), 2) AS avg_transaction_value
FROM walmart_sales_enriched
GROUP BY time_of_day
ORDER BY revenue DESC;

-- 19. Sales by hour
SELECT
    sale_hour,
    COUNT(*) AS transactions,
    ROUND(SUM(total), 2) AS revenue
FROM walmart_sales_enriched
GROUP BY sale_hour
ORDER BY sale_hour;

-- 20. Weekday vs weekend performance
SELECT
    day_type,
    COUNT(*) AS transactions,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(AVG(total), 2) AS avg_transaction_value
FROM walmart_sales_enriched
GROUP BY day_type
ORDER BY revenue DESC;

-- ============================================================
-- 9. BUSINESS-FOCUSED / ADVANCED SQL
-- ============================================================

-- 21. Classify transactions by value
SELECT
    invoice_id,
    total,
    CASE
        WHEN total >= 500 THEN 'High Value'
        WHEN total >= 250 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS transaction_category
FROM walmart_sales_enriched;

-- 22. Top product line in each branch
WITH product_sales AS (
    SELECT
        branch,
        product_line,
        SUM(total) AS revenue
    FROM walmart_sales_enriched
    GROUP BY branch, product_line
),
ranked_products AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY branch
            ORDER BY revenue DESC
        ) AS product_rank
    FROM product_sales
)
SELECT
    branch,
    product_line,
    ROUND(revenue, 2) AS revenue
FROM ranked_products
WHERE product_rank = 1;

-- 23. Running monthly revenue
WITH monthly_sales AS (
    SELECT
        sale_year,
        sale_month,
        month_name,
        SUM(total) AS revenue
    FROM walmart_sales_enriched
    GROUP BY sale_year, sale_month, month_name
)
SELECT
    sale_year,
    sale_month,
    month_name,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY sale_year, sale_month
        ),
        2
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY sale_year, sale_month;

-- 24. Customer segment revenue vs average transaction value
SELECT
    r.customer_type,
    r.revenue,
    a.avg_transaction_value
FROM
(
    SELECT
        customer_type,
        ROUND(SUM(total), 2) AS revenue
    FROM walmart_sales_enriched
    GROUP BY customer_type
) AS r
JOIN
(
    SELECT
        customer_type,
        ROUND(AVG(total), 2) AS avg_transaction_value
    FROM walmart_sales_enriched
    GROUP BY customer_type
) AS a
ON r.customer_type = a.customer_type
ORDER BY r.revenue DESC;

-- 25. Product revenue vs gross income
SELECT
    r.product_line,
    r.revenue,
    g.gross_income
FROM
(
    SELECT
        product_line,
        ROUND(SUM(total), 2) AS revenue
    FROM walmart_sales_enriched
    GROUP BY product_line
) AS r
JOIN
(
    SELECT
        product_line,
        ROUND(SUM(gross_income), 2) AS gross_income
    FROM walmart_sales_enriched
    GROUP BY product_line
) AS g
ON r.product_line = g.product_line
ORDER BY r.revenue DESC;

-- 26. Branch revenue vs customer rating
SELECT
    r.branch,
    r.revenue,
    r.transactions,
    a.avg_rating
FROM
(
    SELECT
        branch,
        ROUND(SUM(total), 2) AS revenue,
        COUNT(*) AS transactions
    FROM walmart_sales_enriched
    GROUP BY branch
) AS r
JOIN
(
    SELECT
        branch,
        ROUND(AVG(rating), 2) AS avg_rating
    FROM walmart_sales_enriched
    GROUP BY branch
) AS a
ON r.branch = a.branch
ORDER BY r.revenue DESC;

-- 27. Revenue contribution by product line
SELECT
    product_line,
    ROUND(SUM(total), 2) AS revenue,
    ROUND(
        SUM(total) * 100 /
        (SELECT SUM(total) FROM walmart_sales_enriched),
        2
    ) AS revenue_percentage
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY revenue DESC;

-- 28. Rank product lines by revenue
SELECT
    product_line,
    ROUND(SUM(total), 2) AS revenue,
    RANK() OVER (
        ORDER BY SUM(total) DESC
    ) AS revenue_rank
FROM walmart_sales_enriched
GROUP BY product_line
ORDER BY revenue_rank;

-- ============================================================
-- END OF WALMART SALES ANALYSIS
-- ============================================================
