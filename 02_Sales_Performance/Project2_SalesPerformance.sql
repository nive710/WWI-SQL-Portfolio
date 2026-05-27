-- ============================================
-- Project 2: Sales Performance
-- Database : WideWorldImporters
-- Tool     : SQL Server (SSMS)
-- Author   : Nivethitha Selvaraj
-- Date     : [03-28-2026]
-- ============================================

USE WideWorldImporters;

-- ============================================
-- BQ1: Who are our highest value customers?
-- ============================================

SELECT TOP 10
    c.CustomerName,
    COUNT(DISTINCT o.OrderID)           AS TotalOrders,
    SUM(ol.Quantity)                    AS TotalItemsPurchased,
    SUM(ol.Quantity * ol.UnitPrice)     AS TotalRevenue
FROM Sales.Customers c
INNER JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN Sales.OrderLines ol
    ON o.OrderID = ol.OrderID
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;

-- Results: Top 10 Customers by Revenue
-- Rank  Customer                            Orders   Items      Revenue
-- 1     Tailspin Toys (Inguadona, MN)       128      16,508     $384,393.35
-- 2     Tailspin Toys (Minidoka, ID)        130      16,445     $379,660.70
-- 3     Mauno Laurila                       120      15,929     $377,189.80
-- 4     Wingtip Toys (Sarversville, PA)     140      16,999     $372,350.00
-- 5     Ingrida Zeltina                     140      15,104     $368,067.45
-- 6     Tailspin Toys (Long Meadow, MD)     122      16,109     $367,258.50
-- 7     Nasrin Omidzadeh                    127      16,999     $366,883.75
-- 8     Wingtip Toys (Cuyamungue, NM)       132      15,841     $365,915.45
-- 9     Wingtip Toys (San Jacinto, CA)      133      16,074     $365,330.95
-- 10    Wingtip Toys (Morrison Bluff, AR)   118      15,460     $360,652.80
--
-- Finding 1: Tailspin Toys and Wingtip Toys dominate the top 10
-- suggesting WWI relies heavily on a small number of retail chains.
--
-- Finding 2: 3 individual customers appear alongside large chains
-- (Mauno Laurila, Ingrida Zeltina, Nasrin Omidzadeh)
-- WWI sells to both retail businesses and individual buyers.
-- These personal accounts generate revenue comparable to
-- large retail chains and are worth retaining.
--
-- Finding 3:
-- Revenue among the top 10 customers is closely distributed,
-- with only a ~$24K difference between the highest and lowest.
-- This suggests WWI is not heavily dependent on a single customer,
-- reducing concentration risk across its top accounts.

-- ============================================
-- BQ2: How are sales reps performing in terms of
--      revenue, orders handled, and customers managed?
-- ============================================

--Creating a View to showcase all the KPIs to evaluate the sales team

CREATE VIEW SalesRepPerformance AS

SELECT
    p.FullName                                                  AS SalesRep,
    COUNT(DISTINCT o.OrderID)                                   AS TotalOrders,
    COUNT(DISTINCT o.CustomerID)                                AS UniqueCustomers,
    SUM(ol.Quantity)                                            AS TotalItemsSold,
    CAST(SUM(ol.Quantity * ol.UnitPrice) AS DECIMAL(10,2))      AS TotalRevenue,
    CAST(SUM(ol.Quantity * ol.UnitPrice) /
         COUNT(DISTINCT o.OrderID) AS DECIMAL(10,2))            AS AvgRevenuePerOrder,
    CAST(SUM(ol.Quantity * ol.UnitPrice) /
         COUNT(DISTINCT o.CustomerID) AS DECIMAL(10,2))         AS AvgRevenuePerCustomer,
    CAST(COUNT(DISTINCT o.OrderID) /
         COUNT(DISTINCT o.CustomerID) AS INT)                   AS AvgOrdersPerCustomer,
    CAST(SUM(ol.Quantity) /
         COUNT(DISTINCT o.OrderID) AS INT)                      AS AvgItemsPerOrder
FROM Sales.Orders o
INNER JOIN Application.People p
    ON o.SalespersonPersonID = p.PersonID
INNER JOIN Sales.OrderLines ol
    ON o.OrderID = ol.OrderID
GROUP BY p.FullName;

-- Running the View 
SELECT * FROM SalesRepPerformance
ORDER BY TotalRevenue DESC;

-- Results: Sales Rep Performance KPI Summary
--
-- Top performer   : Archer Lamble ($18,551,146.95 total revenue)
-- Lowest performer: Anthony Grosse ($17,300,382.20 total revenue)
-- Revenue gap     : ~$1.25M across all 10 reps
--
-- Finding 1: Revenue is evenly distributed across all reps
-- suggesting a well balanced and consistently performing sales team.
--
-- Finding 2: UniqueCustomers per rep ranges from 657 to 662
-- indicating fair and even customer distribution across the team.
--
-- Finding 3: AvgOrdersPerCustomer of 10-11 across all reps
-- indicates strong customer retention and repeat ordering behaviour.
--
-- Finding 4: AvgRevenuePerOrder is consistent at $2,380-$2,460
-- meaning no rep is significantly over or underperforming on order quality.

-- ============================================
-- BQ3: Top and Bottom Revenue Generating States
-- ============================================

WITH StateRevenue AS (

    SELECT
        sp.StateProvinceName                    AS StateName,
        COUNT(DISTINCT c.CustomerID)            AS TotalCustomers,
        COUNT(DISTINCT o.OrderID)               AS TotalOrders,
        CAST(ROUND(SUM(il.ExtendedPrice), 2)
            AS DECIMAL(12,2))                   AS TotalRevenue
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il
        ON i.InvoiceID = il.InvoiceID
    JOIN Sales.Customers c
        ON i.CustomerID = c.CustomerID
    JOIN Application.Cities ct
        ON c.DeliveryCityID = ct.CityID
    JOIN Application.StateProvinces sp
        ON ct.StateProvinceID = sp.StateProvinceID
    JOIN Sales.Orders o
        ON i.OrderID = o.OrderID
    GROUP BY sp.StateProvinceName
),

RankedStates AS (

    SELECT *,
        RANK() OVER (ORDER BY TotalRevenue DESC) AS TopRank,
        RANK() OVER (ORDER BY TotalRevenue ASC)  AS BottomRank
    FROM StateRevenue
)

SELECT
    CASE
        WHEN TopRank <= 5 THEN 'Top 5'
        WHEN BottomRank <= 5 THEN 'Bottom 5'
    END                                          AS Category,
    StateName,
    TotalCustomers,
    TotalOrders,
    TotalRevenue
FROM RankedStates
WHERE TopRank <= 5
   OR BottomRank <= 5
ORDER BY TotalRevenue DESC;

-- Results: Top and Bottom Revenue Generating States
--
-- Top Performing States
-- Rank   State         Customers   Orders    Revenue
-- 1      Texas         46          4,891     $13.75M
-- 2      Pennsylvania  37          3,942     $11.25M
-- 3      California    33          3,690     $10.15M
-- 4      New York      35          3,509     $10.08M
-- 5      Florida       21          2,324     $6.65M
--
-- Bottom Performing States
-- Rank   State         Customers   Orders    Revenue
-- 1      Tennessee     5           516       $1.40M
-- 2      Utah          5           517       $1.38M
-- 3      Connecticut   4           376       $1.06M
-- 4      New Hampshire 5           393       $1.05M
-- 5      Hawaii        1           132       $0.36M
--
-- Findings:
-- Texas generated the highest revenue among all states,
-- supported by a large customer base and high order volume.
--
-- Lower-performing states generated significantly less revenue
-- and generally had fewer customers and transactions.
--
-- The results suggest customer volume is a major driver of
-- regional sales performance across the WWI dataset.
--
-- Revenue distribution varies widely across states, indicating
-- strong regional differences in business activity.
