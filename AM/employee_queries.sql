Assume tables:
employees(emp_id, name, department_id, salary, hire_date)
departments(department_id, department_name, budget)
Query 1 — Select all employees
SQL
SELECT *
FROM employees;
Pandas Equivalent
employees_df
Query 2 — Select employee names and salaries
SQL
SELECT name, salary
FROM employees;
Pandas Equivalent
employees_df[["name", "salary"]]
Query 3 — Employees with salary greater than 60000
SQL
SELECT name, salary
FROM employees
WHERE salary > 60000;
Pandas Equivalent
employees_df[employees_df["salary"] > 60000][["name", "salary"]]
Query 4 — Employees sorted by salary (highest first)
SQL
SELECT name, salary
FROM employees
ORDER BY salary DESC;
Pandas Equivalent
employees_df.sort_values("salary", ascending=False)[["name","salary"]]
Query 5 — Top 5 highest paid employees
SQL
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;
Pandas Equivalent
employees_df.nlargest(5, "salary")[["name","salary"]]
Query 6 — Count total employees
SQL
SELECT COUNT(*) AS total_employees
FROM employees;
Pandas Equivalent
len(employees_df)
Query 7 — Count employees per department
SQL
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;
Pandas Equivalent
employees_df.groupby("department_id").size()
Query 8 — Average salary per department
SQL
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;
Pandas Equivalent
employees_df.groupby("department_id")["salary"].mean()
Query 9 — Departments with average salary greater than 70000
SQL
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 70000;
Pandas Equivalent
employees_df.groupby("department_id")["salary"].mean().loc[lambda x: x >
70000]
Query 10 — Employees hired after January 1, 2022
SQL
SELECT name, hire_date
FROM employees
WHERE hire_date > '2022-01-01';
Pandas Equivalent
employees_df[employees_df["hire_date"] > "2022-01-
01"][["name","hire_date"]]
Query 11 — INNER JOIN employees and departments
SQL
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;
Pandas Equivalent
employees_df.merge(departments_df,
on="department_id")[["name","department_name"]]
Query 12 — LEFT JOIN employees with departments
SQL
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;
Pandas Equivalent
employees_df.merge(departments_df, on="department_id",
how="left")[["name","department_name"]]
Query 13 — Total salary per department
SQL
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id;
Pandas Equivalent
employees_df.groupby("department_id")["salary"].sum()
Query 14 — Maximum salary per department
SQL
SELECT department_id, MAX(salary) AS max_salary
FROM employees
GROUP BY department_id;
Pandas Equivalent
employees_df.groupby("department_id")["salary"].max()
Query 15 — Employees earning above department average salary
SQL
SELECT e.name, e.salary
FROM employees e
JOIN (
 SELECT department_id, AVG(salary) AS avg_salary
 FROM employees
 GROUP BY department_id
) dept_avg
ON e.department_id = dept_avg.department_id
WHERE e.salary > dept_avg.avg_salary;
Pandas Equivalent
dept_avg =
employees_df.groupby("department_id")["salary"].mean().reset_index()
merged = employees_df.merge(dept_avg, on="department_id")
merged[merged["salary"] > merged["salary_y"]][["name","salary"]]
EXPLAIN Query Plan Insights (MySQL)
Example 1
EXPLAIN
SELECT *
FROM employees
WHERE salary > 70000;
Insight:
MySQL may perform a full table scan if no index exists on salary.
Adding an index:
CREATE INDEX idx_salary ON employees(salary);
allows MySQL to use an index range scan, improving performance.
Example 2 — JOIN Query
EXPLAIN
SELECT e.name, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
Insight:
MySQL typically performs a Nested Loop Join, scanning one table and
matching rows from the other table using the join key.
Example 3 — GROUP BY
EXPLAIN
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;
Insight:
MySQL may use temporary tables or filesort when performing aggregation if
indexes are not present on the grouped column.
  
