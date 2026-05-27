# Wide World Importers SQL Portfolio

## Overview
This repository contains a collection of SQL analysis projects built using the Microsoft Wide World Importers (WWI) sample database.

The projects focus on different areas of business analysis including:

- Data profiling and quality assessment
- Sales performance analysis
- Customer segmentation
- Revenue trend analysis

The goal of this portfolio is to demonstrate practical SQL skills used in real-world data analysis scenarios using SQL Server.

---

## Tools Used
- SQL Server
- SQL Server Management Studio (SSMS)
- WideWorldImporters Sample Database

---

## SQL Skills Demonstrated
Across these projects, the following SQL concepts and analytical techniques were used:

- Joins
- Aggregate functions (`SUM`, `COUNT`, `AVG`)
- `GROUP BY`
- `ORDER BY`
- Common Table Expressions (CTEs)
- Window functions (`LAG`, `RANK`, `ROW_NUMBER`)
- Running totals
- Ranking analysis
- Revenue calculations
- Time-series analysis
- Customer segmentation logic
- View creation
- Data profiling and validation

---

# Projects

---

## 1. Data Profiling & Quality Assessment

Performed exploratory data profiling and data quality checks across key WWI tables.

### Key Areas Covered
- NULL value analysis
- Duplicate checks
- Referential integrity validation
- Product and customer coverage analysis
- Table structure exploration

### Skills Demonstrated
- Data validation
- Quality assessment
- Exploratory SQL analysis

📂 Folder: `01_Data_Profiling`

---

## 2. Sales Performance Analysis

Analyzed customer revenue, sales representative performance, and regional sales trends.

### Key Areas Covered
- Top revenue-generating customers
- Sales rep KPI analysis
- Revenue by state
- Customer and order volume analysis

### Skills Demonstrated
- KPI calculations
- View creation
- Ranking analysis
- Revenue analysis

📂 Folder: `02_Sales_Performance`

---

## 3. Customer Segmentation Analysis

Segmented customers based on purchasing behaviour and analyzed revenue contribution across customer groups.

### Key Areas Covered
- Customer category comparison
- Top customers by category
- Behaviour-based customer segmentation
- Revenue contribution by segment

### Skills Demonstrated
- Customer segmentation
- Window functions
- CTEs
- Behaviour analysis

📂 Folder: `03_Customer_Segmentation`

---

## 4. Revenue Trend Analysis

Analyzed monthly and quarterly revenue trends to identify growth patterns, seasonality, and high/low performing periods.

### Key Areas Covered
- Monthly revenue trends
- Quarterly revenue analysis
- Growth percentage calculations
- Running revenue totals
- Top and bottom period analysis

### Skills Demonstrated
- Time-series analysis
- Window functions
- Trend analysis
- Running totals

📂 Folder: `04_Revenue_Trend_Analysis`

---

## Related Power BI Project

### WWI Revenue & Customer Segmentation Dashboard

An interactive Power BI dashboard built using the same WWI dataset covering:

- Revenue trends
- Regional performance
- Customer segmentation
- Drillthrough analysis
- Dynamic DAX insights

🔗 Repository: https://github.com/nive710/WWI-Revenue-and-Customer-Segmentation

---

## Dataset Information

### About the Data
- **Source:** Microsoft Sample Datasets
- **Database:** Wide World Importers (WWI)
- **Type:** Relational database representing a wholesale novelty goods importer.

### Access the Original Dataset
Since the backup file exceeds GitHub's file size limits, the original `.bak` file can be downloaded directly from Microsoft:

- https://github.com/microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Standard.bak

### How to Restore the Database
1. Download the `WideWorldImporters-Standard.bak` file
2. Move it to your SQL Server backup directory
3. Open SQL Server Management Studio (SSMS)
4. Restore the database using the Restore Database wizard

---

## Repository Structure

```text
WWI-SQL-Portfolio
│
├── 01_Data_Profiling
├── 02_Sales_Performance
├── 03_Customer_Segmentation
├── 04_Revenue_Trend_Analysis
└── README.md
```

---

## Author
**Nivethitha Selvaraj**  
Data Analyst | Power BI | SQL | Vancouver, Canada

🔗 LinkedIn: https://www.linkedin.com/in/nivethitha-s/
