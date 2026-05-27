-- ============================================
-- Project 4: Revenue Trend Analysis
-- Database : WideWorldImporters
-- Tool     : SQL Server (SSMS)
-- Author   : Nivethitha Selvaraj
-- Date     : 04-04-2026
-- ============================================
USE WideWorldImporters;
-- ============================================
-- BQ1:How has monthly revenue changed over time,
-- and which months performed the best and worst?
-- ============================================

WITH MonthlyRevenue AS (

    SELECT
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        ) AS MonthStart,

        DATENAME(MONTH, o.OrderDate) + ' ' +
        CAST(YEAR(o.OrderDate) AS VARCHAR(4)) AS MonthName,

        CAST(
            SUM(ol.Quantity * ol.UnitPrice)
            AS DECIMAL(12,2)
        ) AS Revenue

    FROM Sales.Orders o

    JOIN Sales.OrderLines ol
        ON o.OrderID = ol.OrderID

    GROUP BY
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        ),
        DATENAME(MONTH, o.OrderDate),
        YEAR(o.OrderDate)
),

FinalData AS (

    SELECT
        MonthStart,
        MonthName,
        Revenue,

        -- Previous Month Revenue
        LAG(Revenue) OVER (
            ORDER BY MonthStart
        ) AS PrevMonthlyRevenue,

        -- Revenue Growth %
        CASE
            WHEN LAG(Revenue) OVER (
                ORDER BY MonthStart
            ) IS NULL
                THEN NULL

            ELSE CAST(
                (
                    Revenue -
                    LAG(Revenue) OVER (
                        ORDER BY MonthStart
                    )
                ) * 100.0
                /
                LAG(Revenue) OVER (
                    ORDER BY MonthStart
                )
                AS DECIMAL(10,2)
            )
        END AS MonthlyGrowthPct,

        -- Running Revenue
        SUM(Revenue) OVER (
            ORDER BY MonthStart
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS RunningMonthlyRevenue,

        -- Ranking
        ROW_NUMBER() OVER (
            ORDER BY Revenue DESC
        ) AS TopRank,

        ROW_NUMBER() OVER (
            ORDER BY Revenue ASC
        ) AS BottomRank

    FROM MonthlyRevenue
)

SELECT
    MonthName,
    Revenue,
    PrevMonthlyRevenue,
    MonthlyGrowthPct,
    RunningMonthlyRevenue,

    CASE
        WHEN TopRank <= 3 THEN 'Top'
        WHEN BottomRank <= 3 THEN 'Bottom'
        ELSE NULL
    END AS Category

FROM FinalData

WHERE TopRank <= 3
   OR BottomRank <= 3

ORDER BY MonthStart;

-- Results: Top and Bottom Performing Months (Revenue Analysis)
--
-- MonthName       Revenue        PrevRevenue    RevenueGrowthPct   RunningRevenue   Category
-- February 2013   $2,821,282     $3,824,842     -26.24%            $6,646,125       Bottom
-- August 2013     $3,601,220     $4,502,741     -20.02%            $31,584,804      Bottom
-- February 2014   $3,572,744     $4,202,578     -14.99%            $54,703,916      Bottom
-- April 2015      $5,222,594     $4,644,642     12.44%             $117,151,717     Top
-- July 2015       $5,339,212     $4,696,866     13.68%             $131,824,425     Top
-- May 2016        $5,138,002     $4,739,058     8.42%              $177,634,276     Top
--
--
-- Finding 1: February appears twice among the lowest-performing months,
-- indicating a consistent seasonal decline in early-year revenue.
--
-- Finding 2: The lowest revenue recorded was in February 2013 (~$2.82M),
-- with a sharp -26.24% drop from the previous month, marking the most
-- significant decline in the dataset.
--
-- Finding 3: Peak performance occurs in mid-year months, with July 2015
-- recording the highest revenue (~$5.33M), followed by April 2015 and May 2016.
--
-- Finding 4: Top-performing months show strong positive growth rates
-- (8%–14%), indicating high-demand periods and effective revenue generation.
--
-- Finding 5: Bottom-performing months are associated with significant negative
-- growth (-15% to -26%), suggesting recurring seasonal or operational slowdowns.

-- ============================================
-- BQ2: How has quarterly revenue changed over time,
-- and which quarters performed the best and worst?
-- ============================================

WITH QuarterlyRevenue AS (

    SELECT
        CONCAT(
            'Q',
            DATEPART(QUARTER, o.OrderDate),
            ' ',
            YEAR(o.OrderDate)
        ) AS QuarterName,

        DATEFROMPARTS(
            YEAR(o.OrderDate),
            ((DATEPART(QUARTER, o.OrderDate) - 1) * 3) + 1,
            1
        ) AS QuarterStart,

        CAST(
            SUM(ol.Quantity * ol.UnitPrice)
            AS DECIMAL(12,2)
        ) AS Revenue

    FROM Sales.Orders o

    JOIN Sales.OrderLines ol
        ON o.OrderID = ol.OrderID

    GROUP BY
        YEAR(o.OrderDate),
        DATEPART(QUARTER, o.OrderDate)
),

FinalQuarterly AS (

    SELECT
        QuarterName,
        QuarterStart,
        Revenue,

        -- Previous Quarter Revenue
        LAG(Revenue) OVER (
            ORDER BY QuarterStart
        ) AS PrevQuarterRevenue,

        -- Quarterly Growth %
        CASE
            WHEN LAG(Revenue) OVER (
                ORDER BY QuarterStart
            ) IS NULL
                THEN NULL

            ELSE CAST(
                (
                    Revenue -
                    LAG(Revenue) OVER (
                        ORDER BY QuarterStart
                    )
                ) * 100.0
                /
                LAG(Revenue) OVER (
                    ORDER BY QuarterStart
                )
                AS DECIMAL(10,2)
            )
        END AS QuarterlyGrowthPct,

        -- Running Quarterly Revenue
        SUM(Revenue) OVER (
            ORDER BY QuarterStart
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS RunningQuarterlyRevenue,

        -- Ranking
        ROW_NUMBER() OVER (
            ORDER BY Revenue DESC
        ) AS TopRank,

        ROW_NUMBER() OVER (
            ORDER BY Revenue ASC
        ) AS BottomRank

    FROM QuarterlyRevenue
)

SELECT
    QuarterName,
    Revenue,
    PrevQuarterRevenue,
    QuarterlyGrowthPct,
    RunningQuarterlyRevenue,

    CASE
        WHEN TopRank <= 2 THEN 'Top'
        WHEN BottomRank <= 2 THEN 'Bottom'
        ELSE NULL
    END AS Category

FROM FinalQuarterly

WHERE TopRank <= 2
   OR BottomRank <= 2

ORDER BY QuarterStart;

-- Results: Top and Bottom Performing Quarters
--
-- QuarterName   Revenue        PrevQuarterRevenue   QuarterlyGrowthPct   RunningQuarterlyRevenue   Category
-- Q1 2013       $10.95M        NULL                 NULL                  $10.95M                   Bottom
-- Q3 2013       $13.37M        $13.70M              -2.41%                $38.02M                   Bottom
-- Q2 2015       $14.86M        $13.70M              8.47%                 $117.15M                  Top
-- Q3 2015       $15.42M        $14.86M              3.77%                 $132.57M                  Top
--
-- Findings:
-- Q2 and Q3 of 2015 recorded the strongest quarterly revenue,
-- indicating a high-performing growth period for the business.
--
-- Early quarters in 2013 generated the lowest revenue,
-- reflecting the weaker revenue levels seen in the beginning of the dataset.
--
-- Quarterly revenue growth remained relatively stable,
-- with only small fluctuations between consecutive quarters.
--
-- The steadily increasing running revenue confirms
-- consistent long-term business expansion over time.