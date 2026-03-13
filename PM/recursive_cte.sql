1. Generate Numbers 1–100 Using Recursive CTE
SQL
WITH RECURSIVE numbers AS (
SELECT 1 AS num
UNION ALL
SELECT num + 1
FROM numbers
WHERE num < 100
)
SELECT * FROM numbers;
Result: generates numbers 1 to 100 dynamically
2. Fill Missing Dates in Time Series
Assume:
daily_orders(order_date, revenue)
SQL
WITH RECURSIVE dates AS (
SELECT MIN(order_date) AS dt
FROM daily_orders
UNION ALL
SELECT DATE_ADD(dt, INTERVAL 1 DAY)
FROM dates
WHERE dt < (SELECT MAX(order_date) FROM daily_orders)
)
SELECT
d.dt AS date,
COALESCE(SUM(o.revenue),0) AS revenue
FROM dates d
LEFT JOIN daily_orders o
ON d.dt = o.order_date
GROUP BY d.dt
ORDER BY d.dt;
Explanation:
• Recursive CTE generates full date sequence
• LEFT JOIN merges actual data
• COALESCE() converts NULL to 0 revenue
This is a common data engineering interview problem.
