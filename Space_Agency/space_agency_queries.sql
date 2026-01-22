-- 1️ List all projects with their department names
SELECT p.project_name, d.dept_name, p.status
FROM Projects p
JOIN Departments d ON p.dept_id = d.dept_id;

-- 2️ Find total funding received by each project
SELECT p.project_name, SUM(b.amount) AS total_funding
FROM Projects p
JOIN Budgets b ON p.project_id = b.project_id
GROUP BY p.project_name;

-- 3️ Show all employees working under "Mission Control"
SELECT emp_name, position
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Mission Control';

-- 4️ Find the top 2 most funded projects
SELECT p.project_name, SUM(b.amount) AS total_funding
FROM Projects p
JOIN Budgets b ON p.project_id = b.project_id
GROUP BY p.project_name
ORDER BY total_funding DESC
LIMIT 2;

-- 5 Show all ongoing projects with government funding
SELECT p.project_name, f.source_name
FROM Projects p
JOIN Budgets b ON p.project_id = b.project_id
JOIN Funding_Sources f ON b.fund_id = f.fund_id
WHERE p.status = 'Ongoing' AND f.source_type = 'Government';

-- 6. List employees earning above the average salary
SELECT emp_name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 7. Find departments that have more than one project
SELECT d.dept_name, COUNT(p.project_id) AS total_projects
FROM Departments d
JOIN Projects p ON d.dept_id = p.dept_id
GROUP BY d.dept_name
HAVING COUNT(p.project_id) > 1;

-- 8. Display all completed projects with their total funding
SELECT p.project_name, SUM(b.amount) AS total_funding
FROM Projects p
JOIN Budgets b ON p.project_id = b.project_id
WHERE p.status = 'Completed'
GROUP BY p.project_name;

-- 9. Show all projects started after 2022
SELECT project_name, start_date
FROM Projects
WHERE start_date > '2022-12-31';

-- 10. Find employees belonging to departments located in Bengaluru
SELECT e.emp_name, e.position, d.location
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Bengaluru';

-- 11. Increase salary of all 'Scientists' by 10%
SET SQL_SAFE_UPDATES = 0;

UPDATE Employees
SET salary = salary * 1.10
WHERE position = 'Scientist';

SET SQL_SAFE_UPDATES = 1;


-- 12. Delete projects that ended before 2022
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Projects
WHERE end_date < '2022-01-01';

SET SQL_SAFE_UPDATES = 1;

-- 13. Find total salary expense of each department
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM Departments d
JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 14. Display project(s) having maximum funding amount
SELECT p.project_name, b.amount
FROM Projects p
JOIN Budgets b ON p.project_id = b.project_id
WHERE b.amount = (SELECT MAX(amount) FROM Budgets);

-- 15. Count how many projects are currently 'Ongoing'
SELECT COUNT(*) AS total_ongoing_projects
FROM Projects
WHERE status = 'Ongoing';

-- 16. List all funding sources that contributed more than ₹1 crore (10,000,000)
SELECT source_name, source_type
FROM Funding_Sources
WHERE fund_id IN (
    SELECT fund_id
    FROM Budgets
    GROUP BY fund_id
    HAVING SUM(amount) > 10000000
);

-- 17. Show all projects funded by 'Private' organizations
SELECT p.project_name, f.source_name
FROM Projects p
JOIN Budgets b ON p.project_id = b.project_id
JOIN Funding_Sources f ON b.fund_id = f.fund_id
WHERE f.source_type = 'Private';

-- 18. Create a view showing project name, department, and total funds
CREATE VIEW ProjectFundingView AS
SELECT p.project_name, d.dept_name, SUM(b.amount) AS total_funds
FROM Projects p
JOIN Departments d ON p.dept_id = d.dept_id
JOIN Budgets b ON p.project_id = b.project_id
GROUP BY p.project_name, d.dept_name;

-- 19. Display data from the view
SELECT * FROM ProjectFundingView;

-- 20. List all projects whose name contains the word 'Satellite'
SELECT project_name, status
FROM Projects
WHERE project_name LIKE '%Satellite%';
