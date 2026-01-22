-- JIGAR BHALSOD
-- BT23CSE173 CSE SEC-C2

CREATE DATABASE PROJECT;
USE PROJECT;

-- 1. Departments Table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    head_of_dept VARCHAR(100),
    location VARCHAR(100)
);

-- 2. Employees Table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- 3. Projects Table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(150),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- 4. Funding Sources Table
CREATE TABLE Funding_Sources (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    source_name VARCHAR(150),
    source_type VARCHAR(50),   -- Govt / Private / International
    contact_email VARCHAR(100)
);

-- 5. Budgets Table
CREATE TABLE Budgets (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    fund_id INT,
    amount DECIMAL(12,2),
    allocation_date DATE,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (fund_id) REFERENCES Funding_Sources(fund_id)
);

-- Departments
INSERT INTO Departments (dept_name, head_of_dept, location) VALUES
('Satellite Technology', 'Dr. R. Mehta', 'Ahmedabad'),
('Propulsion Systems', 'Dr. S. Iyer', 'Thiruvananthapuram'),
('Mission Control', 'Dr. Kavita Rao', 'Bengaluru'),
('Space Applications', 'Dr. A. Sharma', 'Hyderabad'),
('Research & Development', 'Dr. P. Nair', 'Sriharikota');

-- Employees
INSERT INTO Employees (emp_name, position, salary, dept_id) VALUES
('Amit Verma', 'Scientist', 75000, 1),
('Priya Joshi', 'Research Analyst', 68000, 4),
('Rohit Singh', 'Engineer', 72000, 2),
('Kiran Patel', 'Project Manager', 90000, 3),
('Sneha Reddy', 'Assistant Scientist', 64000, 5);

-- Projects
INSERT INTO Projects (project_name, dept_id, start_date, end_date, status) VALUES
('Chandrayaan Support Program', 1, '2023-01-10', '2024-12-31', 'Ongoing'),
('Gaganyaan Mission', 2, '2022-06-15', '2025-03-20', 'Ongoing'),
('NavIC Satellite Update', 3, '2021-03-01', '2023-11-10', 'Completed'),
('Earth Observation Satellite', 4, '2023-02-05', NULL, 'Ongoing'),
('Reusable Launch Vehicle Test', 5, '2022-09-12', NULL, 'Ongoing');

-- Funding Sources
INSERT INTO Funding_Sources (source_name, source_type, contact_email) VALUES
('Department of Space, Govt. of India', 'Government', 'funds@dos.gov.in'),
('ISRO Alumni Foundation', 'Private', 'support@isroalumni.org'),
('Indian Tech Council', 'Private', 'grants@itc.in'),
('UN Space Research Fund', 'International', 'contact@unspace.org');

-- Budgets
INSERT INTO Budgets (project_id, fund_id, amount, allocation_date) VALUES
(1, 1, 12000000.00, '2023-01-15'),
(2, 1, 25000000.00, '2022-07-01'),
(3, 2, 8000000.00, '2021-04-10'),
(4, 3, 15000000.00, '2023-02-15'),
(5, 4, 18000000.00, '2022-09-20');
