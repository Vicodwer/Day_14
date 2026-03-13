Prompt Used
Give me 3 senior-level SQL interview questions involving
window functions or CTEs. Include the expected answer
and a common mistake candidates make.
AI Question 1 — Top N per Group
Find top 2 products per category.
SQL
SELECT *
FROM (
SELECT
product,
category,
sales,
ROW_NUMBER() OVER(
PARTITION BY category
ORDER BY sales DESC
) AS rank_num
FROM products
) t
WHERE rank_num <= 2;
Common mistake:
Using LIMIT instead of ROW_NUMBER() which only limits global results.
AI Question 2 — Running Balance
Calculate running account balance.
SQL
SELECT
account_id,
transaction_date,
amount,
SUM(amount) OVER(
PARTITION BY account_id
ORDER BY transaction_date
) AS running_balance
FROM transactions;
Common mistake:
Forgetting ORDER BY, which breaks the cumulative logic.
AI Question 3 — Hierarchical Query
List employee hierarchy using recursive CTE.
SQL
WITH RECURSIVE emp_tree AS (
SELECT emp_id, manager_id, name
FROM employees
WHERE manager_id IS NULL
UNION ALL
SELECT e.emp_id, e.manager_id, e.name
FROM employees e
JOIN emp_tree t
ON e.manager_id = t.emp_id
)
SELECT * FROM emp_tree;
Common mistake:
Missing recursion termination condition causing infinite loops.
