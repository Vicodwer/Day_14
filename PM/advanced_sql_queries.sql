1. Running Total Revenue per Product Category
Goal: cumulative revenue ordered by date.
SQL
SELECT
category,
order_date,
revenue,
SUM(revenue) OVER(
 PARTITION BY category
 ORDER BY order_date
) AS running_total
FROM orders
ORDER BY category, order_date;
Explanation:
• PARTITION BY category → running total calculated separately per
category
• ORDER BY order_date → ensures correct cumulative order
2. Top-3 Customers by Revenue per City
Using ROW_NUMBER().
SQL
SELECT *
FROM (
 SELECT
 customer_id,
 city,
 SUM(revenue) AS total_revenue,
 ROW_NUMBER() OVER(
 PARTITION BY city
 ORDER BY SUM(revenue) DESC
 ) AS rank_num
 FROM orders
 GROUP BY customer_id, city
) ranked_customers
WHERE rank_num <= 3;
Explanation:
• Revenue aggregated per customer per city
• ROW_NUMBER() ranks customers
• Filter top 3 per city
3. Month-over-Month Revenue Growth
Using LAG().
SQL
WITH monthly_revenue AS (
SELECT
DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(revenue) AS total_revenue
FROM orders
GROUP BY month
)
SELECT
month,
total_revenue,
LAG(total_revenue) OVER(ORDER BY month) AS previous_month,
((total_revenue -
LAG(total_revenue) OVER(ORDER BY month))
/ LAG(total_revenue) OVER(ORDER BY month))*100
AS percent_change
FROM monthly_revenue;
Flag months with decline >5%
WITH monthly_revenue AS (
SELECT
DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(revenue) AS total_revenue
FROM orders
GROUP BY month
)
SELECT *,
CASE
WHEN percent_change < -5 THEN 'Decline'
ELSE 'Stable'
END AS flag
FROM (
SELECT
month,
total_revenue,
((total_revenue -
LAG(total_revenue) OVER(ORDER BY month))
/
LAG(total_revenue) OVER(ORDER BY month))*100
AS percent_change
FROM monthly_revenue
) growth;
4. Multi-CTE: Departments Where All Employees Earn Above Company
Average
SQL
WITH company_avg AS (
SELECT AVG(salary) AS avg_salary
FROM employees
),
dept_salaries AS (
SELECT department,
MIN(salary) AS min_salary
FROM employees
GROUP BY department
)
SELECT d.department
FROM dept_salaries d
JOIN company_avg c
ON d.min_salary > c.avg_salary;
Explanation:
• company_avg → average salary company-wide
• dept_salaries → minimum salary per department
• If minimum salary > company average, then all employees exceed
average
5. Second Highest Salary per Department (Without Window Functions)
SQL
SELECT
department,
MAX(salary) AS second_highest_salary
FROM employees e1
WHERE salary <
(
SELECT MAX(salary)
FROM employees e2
WHERE e2.department = e1.department
)
GROUP BY department;
Explanation:
• First finds the highest salary per department
• Then finds the maximum salary below that value
