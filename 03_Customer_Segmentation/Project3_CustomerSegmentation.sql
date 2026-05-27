-- ============================================
-- Project 3: Customer Segmentation
-- Database : WideWorldImporters
-- Tool     : SQL Server (SSMS)
-- Author   : Nivethitha Selvaraj
-- Date     : 03-31-2026
-- ============================================

use WideWorldImporters;

-- ============================================
-- BQ1: How do customer categories compare in
--      orders and revenue?
-- ============================================

SELECT
    cc.CustomerCategoryName                         AS CustomerCategory,
    COUNT(DISTINCT c.CustomerID)                    AS TotalCustomers,
    COUNT(DISTINCT o.OrderID)                       AS TotalOrders,
    CAST(COUNT(DISTINCT o.OrderID) /
         NULLIF(COUNT(DISTINCT c.CustomerID), 0) AS INT)    AS AvgOrdersPerCustomer,
    CAST(ISNULL(SUM(ol.Quantity * ol.UnitPrice), 0)
         AS DECIMAL(15,2))                          AS TotalRevenue,
    CAST(ISNULL(SUM(ol.Quantity * ol.UnitPrice), 0) /
         NULLIF(COUNT(DISTINCT c.CustomerID), 0)
         AS DECIMAL(15,2))                          AS AvgRevenuePerCustomer
FROM Sales.CustomerCategories cc
INNER JOIN Sales.Customers c
    ON cc.CustomerCategoryID = c.CustomerCategoryID
LEFT JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.OrderLines ol
    ON o.OrderID = ol.OrderID
GROUP BY cc.CustomerCategoryName
ORDER BY TotalRevenue DESC;

-- Results: Customer Category Comparison
--
-- CustomerCategory   Customers  Orders   AvgOrders  Revenue          AvgRevenue
-- Novelty Shop       459        52,547   114        $127,003,996.00  $276,697.16
-- Supermarket        58         6,022    103        $14,817,528.60   $255,474.63
-- Gift Store         48         5,089    106        $12,036,144.90   $250,753.02
-- Computer Store     51         5,041    98         $11,975,987.20   $234,823.28
-- Corporate          47         4,896    104        $11,800,619.70   $251,077.01
--
-- Note: Agent, Wholesaler, and General Retailer categories
-- exist in Sales.CustomerCategories but have zero customers
-- assigned. These are unused categories in the current dataset.
--
-- Finding 1: Novelty Shop dominates all other categories
-- with 459 customers and $127M in revenue — nearly 9x more
-- than the next highest category.
--
-- Finding 2: Despite fewer customers, Supermarket and Gift Store
-- have comparable AvgRevenuePerCustomer to Novelty Shop
-- suggesting high value individual accounts in those categories.
--
-- Finding 3: All active categories show strong repeat ordering
-- behaviour with AvgOrdersPerCustomer ranging from 98 to 114.

-- ============================================
-- BQ2: Who is the top customer within each
--      category by revenue?
-- ============================================

-- We use a CTE to calculate revenue per customer then apply
-- RANK() to identify the top customer within each category.

WITH CustomerRevenue AS (
    SELECT
        c.CustomerCategoryID                           AS  CustomerCategoryID,
        cc.CustomerCategoryName                         AS CustomerCategory,
        c.CustomerName                                  AS CustomerName,
        COUNT(DISTINCT o.OrderID)                       AS TotalOrders,
        CAST(SUM(ol.Quantity * ol.UnitPrice)
             AS DECIMAL(15,2))                          AS TotalRevenue
    FROM Sales.CustomerCategories cc
    INNER JOIN Sales.Customers c
        ON cc.CustomerCategoryID = c.CustomerCategoryID
    INNER JOIN Sales.Orders o
        ON c.CustomerID = o.CustomerID
    INNER JOIN Sales.OrderLines ol
        ON o.OrderID = ol.OrderID
    GROUP BY c.CustomerCategoryID, cc.CustomerCategoryName, c.CustomerName
),
RankedCustomers AS (
    SELECT 
        CustomerCategoryID,
        CustomerCategory,
        CustomerName,
        TotalOrders,
        TotalRevenue,
        RANK() OVER (
            PARTITION BY CustomerCategory
            ORDER BY TotalRevenue DESC
        )                                               AS RevenueRank
    FROM CustomerRevenue
)
SELECT
    CustomerCategoryID,
    CustomerCategory,
    CustomerName,
    TotalOrders,
    TotalRevenue
FROM RankedCustomers
WHERE RevenueRank = 1
ORDER BY TotalRevenue desc;

-- Results: Top Customer per Category by Revenue
--
-- CustomerCategory  Top Customer                      Orders  Revenue
-- Novelty Shop      Tailspin Toys (Inguadona, MN)     128     $384,393.35
-- Supermarket       Ingrida Zeltina                   140     $368,067.45
-- Gift Store        Camille Authier                   123     $358,675.15
-- Computer Store    Dinh Mai                          130     $357,216.95
-- Corporate         Satish Mittal                     126     $354,974.10
--
-- Finding 1: Novelty Shop leads with the highest value top customer
-- at $384K, consistent with it being the dominant category overall.
--
-- Finding 2: Top customers across all categories are tightly
-- clustered between $354K and $384K suggesting consistently
-- high value accounts exist in every segment.
--
-- Finding 3: All top customers placed between 123 and 140 orders
-- indicating strong repeat purchasing behaviour across all categories.

-- ============================================
-- BQ3: Which customers are one-time buyers
--      vs repeat buyers?
-- ============================================

WITH CustomerOrderCount AS (
    SELECT
        c.CustomerID                            AS CustomerID,
        c.CustomerName                          AS CustomerName,
        cc.CustomerCategoryName                 AS CustomerCategory,
        COUNT(DISTINCT o.OrderID)               AS TotalOrders
    FROM Sales.Customers c
    INNER JOIN Sales.CustomerCategories cc
        ON c.CustomerCategoryID = cc.CustomerCategoryID
    INNER JOIN Sales.Orders o
        ON c.CustomerID = o.CustomerID
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        cc.CustomerCategoryName
),

CustomerValue AS (
    SELECT
        c.CustomerID                            AS CustomerID,
        SUM(ol.Quantity * ol.UnitPrice)         AS TotalRevenue
    FROM Sales.Customers c
    INNER JOIN Sales.Orders o
        ON c.CustomerID = o.CustomerID
    INNER JOIN Sales.OrderLines ol
        ON o.OrderID = ol.OrderID
    GROUP BY
        c.CustomerID
),

CustomerSegmented AS (
    SELECT
        oc.CustomerID,
        oc.CustomerName,
        oc.CustomerCategory,
        oc.TotalOrders,
        v.TotalRevenue,

        CASE
            WHEN oc.TotalOrders = 1
                THEN 'One-time buyer'

            WHEN oc.TotalOrders <= 10
                THEN 'Occasional buyer'

            WHEN oc.TotalOrders <= 50
                THEN 'Regular buyer'

            ELSE 'Loyal buyer'
        END AS CustomerSegment,

        CASE
            WHEN oc.TotalOrders = 1 THEN 1
            WHEN oc.TotalOrders <= 10 THEN 2
            WHEN oc.TotalOrders <= 50 THEN 3
            ELSE 4
        END AS SortOrder

    FROM CustomerOrderCount oc
    INNER JOIN CustomerValue v
        ON oc.CustomerID = v.CustomerID
)

SELECT
    CustomerID,
    CustomerName,
    CustomerCategory,
    CustomerSegment,
    TotalOrders,
    TotalRevenue,
    SortOrder
FROM CustomerSegmented
ORDER BY
    CustomerCategory,
    SortOrder,
    TotalRevenue DESC;

-- Finding 1: Loyal buyers generate most of the
-- orders and revenue across all customer categories.

-- Finding 2: Novelty Shop is the strongest category,
-- with the highest number of loyal customers and revenue.

-- Finding 3: Occasional and regular buyers contribute
-- much lower revenue compared to loyal buyers.

-- Finding 4: Customer value varies even among loyal buyers,
-- showing that not all repeat customers are equally valuable.

-- Overall Conclusion:
-- WWI's revenue is heavily driven by loyal repeat customers,
-- highlighting the importance of customer retention.

-- ============================================
-- BQ3: Customer Segment Summary
-- ============================================

WITH CustomerSegments AS (

    SELECT
        c.CustomerID,
        c.CustomerName,
        COUNT(DISTINCT o.OrderID) AS TotalOrders,

        CAST(
            SUM(ol.Quantity * ol.UnitPrice)
            AS DECIMAL(12,2)
        ) AS TotalRevenue,

        CASE
            WHEN COUNT(DISTINCT o.OrderID) = 1
                THEN 'One-time buyer'

            WHEN COUNT(DISTINCT o.OrderID) BETWEEN 2 AND 10
                THEN 'Occasional buyer'

            WHEN COUNT(DISTINCT o.OrderID) BETWEEN 11 AND 50
                THEN 'Regular buyer'

            ELSE 'Loyal buyer'
        END AS CustomerSegment

    FROM Sales.Customers c
    JOIN Sales.Orders o
        ON c.CustomerID = o.CustomerID
    JOIN Sales.OrderLines ol
        ON o.OrderID = ol.OrderID
    GROUP BY
        c.CustomerID,
        c.CustomerName
)

SELECT
    CustomerSegment,
    COUNT(CustomerID)                       AS TotalCustomers,
    SUM(TotalOrders)                        AS TotalOrders,

    CAST(SUM(TotalRevenue)
        AS DECIMAL(12,2))                   AS TotalRevenue,

    CAST(AVG(TotalRevenue)
        AS DECIMAL(12,2))                   AS AvgRevenuePerCustomer

FROM CustomerSegments
GROUP BY CustomerSegment

ORDER BY TotalRevenue DESC;

-- Summary:
-- This query provides a high-level summary of customer segments
-- based on purchasing behaviour, including customer count,
-- order volume, and revenue contribution by segment.