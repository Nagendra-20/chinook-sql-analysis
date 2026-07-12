-- ============================================================
-- Chinook Music Store Sales Analysis
-- Database: Chinook (MySQL version)
-- Author: N Nagendra
-- ============================================================

-- Query 1: Ranks customers within each country by total spend
SELECT c.Country, c.FirstName, c.LastName, SUM(i.Total) AS TotalSpent,
       RANK() OVER (PARTITION BY c.Country ORDER BY SUM(i.Total) DESC) AS CountryRank
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY c.Country, CountryRank;


-- Query 2: Month-over-month revenue growth using window functions (LAG)
WITH monthly AS (
  SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, SUM(Total) AS Revenue
  FROM invoice
  GROUP BY Month
)
SELECT Month, Revenue,
       LAG(Revenue) OVER (ORDER BY Month) AS PrevMonth,
       ROUND((Revenue - LAG(Revenue) OVER (ORDER BY Month)) * 100.0 / LAG(Revenue) OVER (ORDER BY Month), 2) AS GrowthPct
FROM monthly;


-- Query 3: Revenue by genre
SELECT g.Name AS Genre, SUM(ii.UnitPrice * ii.Quantity) AS Revenue
FROM invoiceline ii
JOIN track t ON ii.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Revenue DESC;

-- Finding: Rock and Latin genres together drove ~52% of total revenue
-- (Rock: 35.5%, Latin: 16.4%, Metal: 11.2%, Alternative & Punk: 10.4%)
-- Top 4 genres combined accounted for ~74% of total revenue.


-- Query 4: Flags customers with no purchase in the last 180+ days (churn signal)
SELECT c.CustomerId, c.FirstName, c.LastName, MAX(i.InvoiceDate) AS LastPurchase,
       CASE WHEN DATEDIFF(CURDATE(), MAX(i.InvoiceDate)) > 180 THEN 'Inactive' ELSE 'Active' END AS Status
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId;
