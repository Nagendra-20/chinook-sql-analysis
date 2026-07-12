# Chinook Music Store Sales Analysis (SQL)

SQL analysis of the Chinook sample database, exploring customer spending patterns,
revenue trends, and a simple churn signal.

## Dataset
Chinook sample database (customers, invoices, tracks, genres, employees).

## Key queries
- Ranked customers by total spend within each country using window functions
- Calculated month-over-month revenue growth using LAG()
- Identified top revenue-generating genres
- Flagged inactive customers (no purchase in 180+ days) as a churn signal

## Key finding
Rock and Latin genres together drove ~52% of total revenue. The top 4 genres
(Rock, Latin, Metal, Alternative & Punk) accounted for ~74% of total revenue.

## Tools
MySQL, MySQL Workbench
