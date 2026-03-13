Create Projects Table
CREATE TABLE projects (
 project_id INT AUTO_INCREMENT PRIMARY KEY,
 project_name VARCHAR(100),
 lead_emp_id INT,
 budget DECIMAL(12,2),
 start_date DATE,
 end_date DATE
);
Insert Sample Data
INSERT INTO projects (project_name, lead_emp_id, budget, start_date,
end_date)
VALUES
('AI Recommendation Engine',1,200000,'2024-01-10','2024-07-01'),
('Customer Analytics',2,150000,'2024-02-01','2024-08-01'),
('Inventory Automation',3,100000,'2024-03-01','2024-09-01'),
('Fraud Detection',4,180000,'2024-01-15','2024-06-30'),
('Chatbot Assistant',5,120000,'2024-02-20','2024-07-15');
3-Table JOIN
SELECT
e.name AS employee_name,
d.budget AS department_budget,
p.budget AS project_budget
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN projects p
ON e.emp_id = p.lead_emp_id;
Departments where total project budget exceeds department budget
SELECT
d.department_name,
SUM(p.budget) AS total_project_budget,
d.budget AS department_budget
FROM departments d
JOIN employees e
ON d.department_id = e.department_id
JOIN projects p
ON e.emp_id = p.lead_emp_id
GROUP BY d.department_name, d.budget
HAVING SUM(p.budget) > d.budget;
