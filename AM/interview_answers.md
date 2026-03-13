Q1 Logical Execution Order of SQL
Execution order:
FROM
JOIN
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
Why it matters:
Aliases defined in the SELECT clause cannot be used in the WHERE clause
because WHERE executes before SELECT.
Example that fails:
SELECT salary*12 AS annual_salary
FROM employees
WHERE annual_salary > 100000;
Q2 Single Query
(MySQL 8+ supports window functions)
SELECT
name,
salary,
AVG(salary) OVER (PARTITION BY department_id) AS department_avg
FROM employees
WHERE salary > (
 SELECT AVG(salary)
 FROM employees
);
Q3 Debugged Query
Original bug: Aggregate function in WHERE.
Correct query:
SELECT department, AVG(salary) AS avg_sal
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;
