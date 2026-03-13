Q1 Difference Between RANK() and DENSE_RANK()
RANK()
If there is a tie, ranks are skipped.
Example salaries:
90000
85000
85000
80000
Ranks:
1
2
2
4
Rank 3 is skipped.
DENSE_RANK()
Ranks remain consecutive.
1
2
2
3
When It Matters in Business
Example: Top-3 salespeople bonus
Using RANK():
• If two people tie for 2nd place
• No 3rd place exists
Using DENSE_RANK():
• Still assigns a 3rd place
Thus business rules determine which ranking to use.
Q2 Coding — Users With Purchases in 3 Consecutive Months
Table:
transactions(user_id, transaction_date, amount)
SQL
WITH monthly_txn AS (
SELECT
user_id,
DATE_FORMAT(transaction_date,'%Y-%m') AS month
FROM transactions
GROUP BY user_id, month
),
ordered_txn AS (
SELECT
user_id,
month,
LAG(month,1) OVER(PARTITION BY user_id ORDER BY month) AS prev1,
LAG(month,2) OVER(PARTITION BY user_id ORDER BY month) AS prev2
FROM monthly_txn
)
SELECT DISTINCT user_id
FROM ordered_txn
WHERE
PERIOD_DIFF(REPLACE(month,'-',''),
REPLACE(prev1,'-','')) = 1
AND
PERIOD_DIFF(REPLACE(prev1,'-',''),
REPLACE(prev2,'-','')) = 1;
This identifies three consecutive months of activity.
Q3 Optimising Correlated Subquery
Original query:
SELECT name, salary
FROM employees e1
WHERE salary >
(
SELECT AVG(salary)
FROM employees e2
WHERE e2.department = e1.department
);
Problem:
• Correlated subquery executes once per row
• Complexity ≈ O(n²)
Optimised Query Using Window Function
SELECT name, salary
FROM (
SELECT
name,
salary,
AVG(salary) OVER(PARTITION BY department) AS dept_avg
FROM employees
) t
WHERE salary > dept_avg;
Why faster:
• Window function computes averages once per partition
• Avoids repeated scanning of the table
• Complexity closer to O(n)
