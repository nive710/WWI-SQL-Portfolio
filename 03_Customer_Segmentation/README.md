# Project 3: Customer Segmentation Analysis

## Overview
This project analyzes customer behaviour and segmentation in the Microsoft Wide World Importers (WWI) database using SQL Server.

The analysis focuses on customer categories, purchasing behaviour, customer loyalty, and revenue contribution to better understand how different customer groups impact overall business performance.

---

## Goals of the Analysis
The main goals were to:

- Compare customer categories by orders and revenue
- Identify the top customer within each category
- Segment customers based on purchasing behaviour
- Analyze how different customer segments contribute to revenue

---

## Tools Used
- SQL Server
- SQL Server Management Studio (SSMS)
- WideWorldImporters Sample Database

---

## Tables Used
The analysis focused on these main tables:

- `Sales.Customers`
- `Sales.CustomerCategories`
- `Sales.Orders`
- `Sales.OrderLines`

---

## SQL Skills Demonstrated
- Joins
- Aggregate functions (`SUM`, `COUNT`, `AVG`)
- `GROUP BY`
- `CASE WHEN`
- Common Table Expressions (CTEs)
- Window functions (`RANK`)
- Customer segmentation logic
- Revenue analysis
- Behaviour-based categorization

---

## Business Questions Answered

### 1. How do customer categories compare in orders and revenue?

Compared customer categories using customer count, orders, revenue, and average revenue per customer.

[View Screenshot](screenshots/bq1_category_summary.PNG)

---

### 2. Who is the top customer within each category by revenue?

Used ranking functions to identify the highest revenue-generating customer within each customer category.

[View Screenshot](screenshots/bq2_top_customer_category.PNG)

---

### 3. How do customer segments contribute to overall revenue?

Created a detailed customer segmentation query based on purchasing behaviour, along with a summarized segment-level analysis showing customer count, order volume, and revenue contribution by segment.

[View Screenshot](screenshots/bq3_customer_segment_summary.PNG)

---

## Key Findings

- Loyal buyers generate most of the orders and revenue across all customer categories.
- Novelty Shop is the strongest category, with the highest number of loyal customers and revenue.
- Occasional and regular buyers contribute much lower revenue compared to loyal buyers.
- Customer value varies even among loyal buyers, showing that not all repeat customers are equally valuable.
- WWI's revenue is heavily driven by loyal repeat customers, highlighting the importance of customer retention.

---

## SQL File
[Project3_Customer_Segmentation.sql](https://github.com/nive710/WWI-SQL-Portfolio/blob/3c83ffdc055f797e64412eb72d468e9f6ac07ea1/03_Customer_Segmentation/Project3_CustomerSegmentation.sql)

---

## Related Projects
- [WWI Revenue & Customer Segmentation Dashboard (Power BI)](https://github.com/nive710/WWI-Power-BI-Portfolio)
---

## Author
**Nivethitha Selvaraj**  
Data Analyst | Power BI | SQL | Vancouver, Canada

[Connect on LinkedIn](https://www.linkedin.com/in/nivethitha-s/)
