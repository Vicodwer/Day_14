Prompt Used
Generate 5 medium-difficulty SQL interview questions for a data engineer role,
with answers. Include one about JOINs, one about NULL handling,
and one about performance.
Example AI Questions
JOIN Question
SELECT e.name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.budget > 100000;
NULL Handling
SELECT COUNT(*)
FROM employees
WHERE department_id IS NULL;
Performance Query
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;
Improvement:
Create an index:
CREATE INDEX idx_salary ON employees(salary);
