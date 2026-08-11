# Walmart Sales Analysis — SQL

A business-focused SQL analysis of 1,000 Walmart sales transactions, designed to identify revenue drivers, product performance, branch performance, customer behavior, and sales trends.

## Project Overview

This project uses MySQL to analyze Walmart transaction data across three retail branches in Myanmar.

The analysis covers:

- Revenue and gross-income performance
- Branch and city comparison
- Product-line performance
- Customer-type behavior
- Payment-method usage
- Sales by day and time
- Customer ratings
- Revenue contribution
- Transaction-value segmentation
- Ranking and cumulative analysis

## Dataset

The dataset contains **1,000 transactions** and includes fields such as:

- Invoice ID
- Branch
- City
- Customer Type
- Gender
- Product Line
- Unit Price
- Quantity
- Tax
- Total
- Sale Date
- Sale Time
- Payment Method
- COGS
- Gross Income
- Customer Rating

## Tech Stack

- **MySQL**
- **MySQL Workbench**
- SQL

SQL concepts used include:

- `SELECT`
- Filtering
- `GROUP BY`
- `HAVING`
- Aggregate functions
- `CASE`
- Subqueries
- CTEs
- Window functions
- `RANK()`
- `JOIN`
- Date/time functions
- Feature engineering

## Project Workflow

```text
Raw CSV
   ↓
MySQL Import
   ↓
Data Validation
   ↓
Feature Engineering
   ↓
Business-focused SQL Analysis
   ↓
Revenue / Product / Branch / Customer Insights
```

## Key Results

### Overall Performance

| Metric | Result |
|---|---:|
| Transactions | 1,000 |
| Total Revenue | 322,967.43 |
| Gross Income | 15,380.05 |
| Units Sold | 5,510 |
| Average Transaction Value | 322.97 |
| Average Customer Rating | 6.97 / 10 |

### Branch Performance

| Branch | City | Revenue |
|---|---|---:|
| C | Naypyitaw | 110,568.86 |
| A | Yangon | 106,200.57 |
| B | Mandalay | 106,198.00 |

**Insight:** Branch C generated the highest revenue at **110,568.86**, contributing approximately **34.2% of total revenue**.

### Product Performance

| Product Line | Revenue | Units Sold |
|---|---:|---:|
| Food and beverages | 56,144.96 | 952 |
| Sports and travel | 55,123.00 | 920 |
| Electronic accessories | 54,337.64 | 971 |
| Fashion accessories | 54,306.03 | 902 |
| Home and lifestyle | 53,861.96 | 911 |
| Health and beauty | 49,193.84 | 854 |

**Insight:** Food and beverages generated the highest revenue at **56,144.96**.

**Additional insight:** Electronic accessories sold the highest number of units (**971**) but did not generate the highest revenue, showing that sales volume and revenue are not necessarily the same.

### Customer Performance

| Customer Type | Transactions | Revenue | Avg. Transaction |
|---|---:|---:|---:|
| Member | 501 | 164,223.81 | 327.79 |
| Normal | 499 | 158,743.62 | 318.12 |

**Insight:** Member customers generated approximately **50.9% of total revenue** and had a higher average transaction value than normal customers.

## SQL Analysis

The main SQL file contains **28 business-focused analytical queries**, organized into:

1. Overall business performance
2. Branch analysis
3. Product analysis
4. Customer analysis
5. Time/sales trend analysis
6. Advanced SQL/business analysis

The queries demonstrate practical use of SQL rather than isolated syntax exercises.

## Repository Structure

```text
Walmart-Sales-Analysis/
│
├── data/
│   └── WalmartSalesData.csv
│
├── sql/
│   └── Walmart_Sales_Analysis.sql
│
└── README.md
```

## How to Run

1. Install MySQL and MySQL Workbench.
2. Create the database.
3. Import the Walmart CSV into the `walmart_sales` table.
4. Open `sql/Walmart_Sales_Analysis.sql`.
5. Select the database:
   ```sql
   USE walmart_sales_analysis;
   ```
6. Execute the analysis queries.

## Resume Project

**Walmart Sales Analysis | SQL**

- Analyzed **1,000+ Walmart sales transactions** using SQL to uncover revenue trends, customer purchasing patterns, and branch-wise performance across 3 retail locations.
- Performed **data cleaning and feature engineering** by creating time-based attributes for deeper sales and customer-behavior analysis.
- Developed **25+ business-focused SQL queries** using joins, subqueries, aggregate functions, CASE statements, and window functions to identify top-performing product lines and revenue drivers.

## Disclaimer

This is a portfolio/academic analytics project using a Walmart sales dataset. The project focuses on practical SQL, data preparation, feature engineering, and business analytics.
