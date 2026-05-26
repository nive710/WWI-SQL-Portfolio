-- ============================================
-- Project 1: Data Profiling & Quality Assesment
-- Database : WideWorldImporters
-- Tool     : SQL Server (SSMS)
-- Author   : Nivethitha Selvaraj
-- Date     : [03-27-2026]
-- ============================================

USE WideWorldImporters;

-- ============================================
-- BQ1: How many records exist in each key table?
-- ============================================

SELECT 'Sales.Customers'             AS TableName, COUNT(*) AS Row_Count FROM Sales.Customers
UNION ALL
SELECT 'Sales.Orders'                AS TableName, COUNT(*) AS Row_Count FROM Sales.Orders
UNION ALL
SELECT 'Sales.OrderLines'            AS TableName, COUNT(*) AS Row_Count FROM Sales.OrderLines
UNION ALL
SELECT 'Application.People'          AS TableName, COUNT(*) AS Row_Count FROM Application.People
UNION ALL
SELECT 'Warehouse.StockItems'        AS TableName, COUNT(*) AS Row_Count FROM Warehouse.StockItems
UNION ALL
SELECT 'Warehouse.StockItemHoldings' AS TableName, COUNT(*) AS Row_Count FROM Warehouse.StockItemHoldings;

-- Results:
-- Sales.Customers             : 663 rows
-- Sales.Orders                : 73,595 rows
-- Sales.OrderLines            : 231,412 rows
-- Application.People          : 1,111 rows
-- Warehouse.StockItems        : 227 rows
-- Warehouse.StockItemHoldings : 227 rows

-- ============================================
-- BQ2: Are there missing values in any critical columns?
-- ============================================

-- Sales.Customers
SELECT 'Sales.Customers' AS TableName, 'CustomerName' AS ColumnName,
    SUM(CASE WHEN CustomerName IS NULL THEN 1 ELSE 0 END) AS NullCount FROM Sales.Customers
UNION ALL
SELECT 'Sales.Customers', 'CustomerID',
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) FROM Sales.Customers
UNION ALL
SELECT 'Sales.Customers', 'PrimaryContactPersonID',
    SUM(CASE WHEN PrimaryContactPersonID IS NULL THEN 1 ELSE 0 END) FROM Sales.Customers
UNION ALL
SELECT 'Sales.Customers', 'CreditLimit',
    SUM(CASE WHEN CreditLimit IS NULL THEN 1 ELSE 0 END) FROM Sales.Customers

UNION ALL

-- Sales.Orders
SELECT 'Sales.Orders', 'OrderID',
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) FROM Sales.Orders
UNION ALL
SELECT 'Sales.Orders', 'CustomerID',
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) FROM Sales.Orders
UNION ALL
SELECT 'Sales.Orders', 'OrderDate',
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) FROM Sales.Orders
UNION ALL
SELECT 'Sales.Orders', 'SalespersonPersonID',
    SUM(CASE WHEN SalespersonPersonID IS NULL THEN 1 ELSE 0 END) FROM Sales.Orders

UNION ALL

-- Sales.OrderLines
SELECT 'Sales.OrderLines', 'OrderLineID',
    SUM(CASE WHEN OrderLineID IS NULL THEN 1 ELSE 0 END) FROM Sales.OrderLines
UNION ALL
SELECT 'Sales.OrderLines', 'OrderID',
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) FROM Sales.OrderLines
UNION ALL
SELECT 'Sales.OrderLines', 'Quantity',
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) FROM Sales.OrderLines
UNION ALL
SELECT 'Sales.OrderLines', 'UnitPrice',
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) FROM Sales.OrderLines
UNION ALL
SELECT 'Sales.OrderLines', 'StockItemID',
    SUM(CASE WHEN StockItemID IS NULL THEN 1 ELSE 0 END) FROM Sales.OrderLines

UNION ALL

-- Warehouse.StockItems
SELECT 'Warehouse.StockItems', 'StockItemID',
    SUM(CASE WHEN StockItemID IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItems
UNION ALL
SELECT 'Warehouse.StockItems', 'StockItemName',
    SUM(CASE WHEN StockItemName IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItems
UNION ALL
SELECT 'Warehouse.StockItems', 'UnitPrice',
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItems
UNION ALL
SELECT 'Warehouse.StockItems', 'SupplierID',
    SUM(CASE WHEN SupplierID IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItems

UNION ALL

-- Warehouse.StockItemHoldings
SELECT 'Warehouse.StockItemHoldings', 'StockItemID',
    SUM(CASE WHEN StockItemID IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItemHoldings
UNION ALL
SELECT 'Warehouse.StockItemHoldings', 'QuantityOnHand',
    SUM(CASE WHEN QuantityOnHand IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItemHoldings
UNION ALL
SELECT 'Warehouse.StockItemHoldings', 'ReorderLevel',
    SUM(CASE WHEN ReorderLevel IS NULL THEN 1 ELSE 0 END) FROM Warehouse.StockItemHoldings

UNION ALL

-- Application.People
SELECT 'Application.People', 'PersonID',
    SUM(CASE WHEN PersonID IS NULL THEN 1 ELSE 0 END) FROM Application.People
UNION ALL
SELECT 'Application.People', 'FullName',
    SUM(CASE WHEN FullName IS NULL THEN 1 ELSE 0 END) FROM Application.People
UNION ALL
SELECT 'Application.People', 'EmailAddress',
    SUM(CASE WHEN EmailAddress IS NULL THEN 1 ELSE 0 END) FROM Application.People

ORDER BY TableName, NullCount DESC;

-- Results:
-- Total columns checked        : 23
-- Clean columns (NullCount = 0): 21
-- Columns with nulls           : 2
--
-- Finding 1: Sales.Customers.CreditLimit — 402 nulls
-- Not all customers are assigned a credit limit.
-- This is expected business behaviour and does not affect revenue or sales analysis.
--
-- Finding 2: Application.People.EmailAddress — 1 null
-- One person record has no email address on file.
-- This will not impact any queries in this portfolio.
--
-- Conclusion: Dataset is clean and ready for analysis.
-- All critical columns used in portfolio queries have zero null values.

-- ============================================
-- BQ3: Are there any duplicate primary keys across key tables?
-- ============================================

SELECT 'Sales.Customers' AS TableName, 'CustomerID' AS PrimaryKey,
    COUNT(*) AS DuplicateCount
FROM (
    SELECT CustomerID FROM Sales.Customers
    GROUP BY CustomerID HAVING COUNT(*) > 1
) AS Dupe

UNION ALL

SELECT 'Sales.Orders', 'OrderID',
    COUNT(*)
FROM (
    SELECT OrderID FROM Sales.Orders
    GROUP BY OrderID HAVING COUNT(*) > 1
) AS Dupe

UNION ALL

SELECT 'Sales.OrderLines', 'OrderLineID',
    COUNT(*)
FROM (
    SELECT OrderLineID FROM Sales.OrderLines
    GROUP BY OrderLineID HAVING COUNT(*) > 1
) AS Dupe

UNION ALL

SELECT 'Warehouse.StockItems', 'StockItemID',
    COUNT(*)
FROM (
    SELECT StockItemID FROM Warehouse.StockItems
    GROUP BY StockItemID HAVING COUNT(*) > 1
) AS Dupe

UNION ALL

SELECT 'Warehouse.StockItemHoldings', 'StockItemID',
    COUNT(*)
FROM (
    SELECT StockItemID FROM Warehouse.StockItemHoldings
    GROUP BY StockItemID HAVING COUNT(*) > 1
) AS Dupe

UNION ALL

SELECT 'Application.People', 'PersonID',
    COUNT(*)
FROM (
    SELECT PersonID FROM Application.People
    GROUP BY PersonID HAVING COUNT(*) > 1
) AS Dupe

ORDER BY DuplicateCount DESC;

-- Results:
-- Total tables checked         : 6
-- Total columns checked        : 6 (primary keys only)
-- Tables with duplicates       : 0
--
-- Conclusion: No duplicate primary keys found in any table.

-- ============================================
-- BQ4: What time period does the data cover?
-- ============================================

SELECT 'Sales.Orders' AS TableName, 'OrderDate' AS DateColumn,
    FORMAT(MIN(OrderDate), 'MM-dd-yyyy')                            AS EarliestDate,
    FORMAT(MAX(OrderDate), 'MM-dd-yyyy')                            AS LatestDate,
    DATEDIFF(YEAR,  MIN(OrderDate), MAX(OrderDate))                 AS YearsOfData,
    DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) % 12            AS MonthsRemainder,
    COUNT(*)                                                        AS TotalRows
FROM Sales.Orders

UNION ALL

SELECT 'Sales.Invoices', 'InvoiceDate',
    FORMAT(MIN(InvoiceDate), 'MM-dd-yyyy'),
    FORMAT(MAX(InvoiceDate), 'MM-dd-yyyy'),
    DATEDIFF(YEAR,  MIN(InvoiceDate), MAX(InvoiceDate)),
    DATEDIFF(MONTH, MIN(InvoiceDate), MAX(InvoiceDate)) % 12,
    COUNT(*)
FROM Sales.Invoices

UNION ALL

SELECT 'Warehouse.StockItemTransactions', 'TransactionOccurredWhen',
    FORMAT(MIN(TransactionOccurredWhen), 'MM-dd-yyyy'),
    FORMAT(MAX(TransactionOccurredWhen), 'MM-dd-yyyy'),
    DATEDIFF(YEAR,  MIN(TransactionOccurredWhen), MAX(TransactionOccurredWhen)),
    DATEDIFF(MONTH, MIN(TransactionOccurredWhen), MAX(TransactionOccurredWhen)) % 12,
    COUNT(*)
FROM Warehouse.StockItemTransactions

UNION ALL

SELECT 'Purchasing.PurchaseOrders', 'OrderDate',
    FORMAT(MIN(OrderDate), 'MM-dd-yyyy'),
    FORMAT(MAX(OrderDate), 'MM-dd-yyyy'),
    DATEDIFF(YEAR,  MIN(OrderDate), MAX(OrderDate)),
    DATEDIFF(MONTH, MIN(OrderDate), MAX(OrderDate)) % 12,
    COUNT(*)
FROM Purchasing.PurchaseOrders

ORDER BY TableName;

-- Results:
-- All tables cover the same period: 01-01-2013 to 05-31-2016
-- YearsOfData    : 3
-- MonthsRemainder: 4
-- Meaning        : 3 years and 4 months of data across all tables
--
-- Table row counts:
-- Sales.Orders                    : 73,595 rows
-- Sales.Invoices                  : 70,510 rows
-- Purchasing.PurchaseOrders       : 2,074  rows
-- Warehouse.StockItemTransactions : 236,667 rows
--
-- Note: Orders (73,595) slightly exceeds Invoices (70,510)
-- meaning ~3,085 orders were placed but never invoiced.
-- This is normal business behaviour and does not affect 
-- our sales analysis which is based on Orders, not Invoices.
--
-- Conclusion: Data is consistent across all tables and spans
-- a sufficient period for monthly and yearly trend analysis.

-- ============================================
-- BQ5: How many unique entities exist in each table?
-- ============================================

SELECT 'Sales.Customers' AS TableName, COUNT(*) AS TotalCount, COUNT(DISTINCT CustomerID) AS DistinctCount
FROM Sales.Customers

UNION ALL

SELECT 'Sales.Orders', COUNT(*), COUNT(DISTINCT OrderID)
FROM Sales.Orders

UNION ALL

SELECT 'Sales.OrderLines', COUNT(*), COUNT(DISTINCT StockItemID)
FROM Sales.OrderLines

UNION ALL

SELECT 'Warehouse.StockItems', COUNT(*), COUNT(DISTINCT StockItemID)
FROM Warehouse.StockItems

UNION ALL

SELECT 'Application.People', COUNT(*), COUNT(DISTINCT PersonID)
FROM Application.People

ORDER BY TableName;

-- Results:
-- Application.People    : 1,111 total / 1,111 distinct (all unique)
-- Sales.Customers       : 663   total / 663   distinct (all unique)
-- Sales.Orders          : 73,595 total / 73,595 distinct (all unique)
-- Warehouse.StockItems  : 227   total / 227   distinct (all unique)
-- Sales.OrderLines      : 231,412 total / 227 distinct StockItemIDs
--
-- Note: Sales.OrderLines contains 231,412 rows but only 227
-- distinct StockItemIDs because the same products appear in
-- many different customer orders. This is expected behavior
-- for a transaction-level sales table.
--
-- Conclusion: All primary key columns are fully unique.
-- Dataset scale is well suited for meaningful analysis.
