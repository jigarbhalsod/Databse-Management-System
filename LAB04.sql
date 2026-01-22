/*
==========================================================
LAB04 : Company Database (EMPLOYEE–DEPARTMENT–PROJECT)
DBMS / SQL Lab Assignment
----------------------------------------------------------
Problem Context:
This database models a company with:
- Employees
- Departments
- Projects
- Employee–Project assignments

The lab focuses on:
- JOINs
- Correlated subqueries
- Division-style queries using NOT EXISTS
- UNION of multiple logical conditions

==========================================================
*/

-- --------------------------------------------------------
-- 1. DATABASE SETUP
-- --------------------------------------------------------
DROP DATABASE IF EXISTS LAB04;
CREATE DATABASE LAB04;
USE LAB04;

-- --------------------------------------------------------
-- 2. EMPLOYEE TABLE
-- --------------------------------------------------------
CREATE TABLE EMPLOYEE (
    Fname VARCHAR(20),
    Minit CHAR(1),
    Lname VARCHAR(20),
    Ssn CHAR(9) PRIMARY KEY,
    Bdate DATE,
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT
);

-- --------------------------------------------------------
-- 3. DEPARTMENT TABLE
-- --------------------------------------------------------
CREATE TABLE DEPARTMENT (
    Dname VARCHAR(20),
    Dnumber INT PRIMARY KEY,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE
);

-- --------------------------------------------------------
-- 4. PROJECT TABLE
-- --------------------------------------------------------
CREATE TABLE PROJECT (
    Pname VARCHAR(20),
    Pnumber INT PRIMARY KEY,
    Plocation VARCHAR(20),
    Dnum INT
);

-- --------------------------------------------------------
-- 5. WORKS_ON TABLE
-- (Relationship between EMPLOYEE and PROJECT)
-- --------------------------------------------------------
CREATE TABLE WORKS_ON (
    Essn CHAR(9),
    Pno INT,
    Hours DECIMAL(4,1),
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
);

-- --------------------------------------------------------
-- 6. INSERT DATA : DEPARTMENTS
-- --------------------------------------------------------
INSERT INTO DEPARTMENT VALUES
('Research',5,'333445555','2015-01-01'),
('Admin',15,'987654321','2016-03-15');

-- --------------------------------------------------------
-- 7. INSERT DATA : EMPLOYEES
-- --------------------------------------------------------
INSERT INTO EMPLOYEE VALUES
('John','B','Smith','123456789','1980-05-05','Houston','M',60000,NULL,5),
('Anna','K','Brown','333445555','1975-09-10','Dallas','F',80000,NULL,5),
('Ramesh','T','Kumar','987654321','1978-11-20','Mumbai','M',90000,NULL,15),
('Suresh','M','Patel','888665555','1982-07-15','Pune','M',50000,'987654321',15);

-- --------------------------------------------------------
-- 8. INSERT DATA : PROJECTS
-- --------------------------------------------------------
INSERT INTO PROJECT VALUES
('AI',1,'Dallas',15),
('ML',2,'Houston',15),
('DB',3,'Mumbai',5);

-- --------------------------------------------------------
-- 9. INSERT DATA : WORKS_ON
-- --------------------------------------------------------
INSERT INTO WORKS_ON VALUES
('123456789',1,10),
('123456789',2,15),
('333445555',1,20),
('333445555',2,20),
('987654321',1,25),
('987654321',2,25),
('888665555',3,30);

-- ========================================================
-- 10. QUERIES DISCUSSED IN LAB
-- ========================================================

-- Q1: Retrieve the name and address of employees
--     who work for the 'Research' department
SELECT E.Fname, E.Lname, E.Address
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Dno = D.Dnumber
WHERE D.Dname = 'Research';

-- --------------------------------------------------------

-- Q2: Find names of employees who work on ALL projects
--     controlled by department number 15
-- (Division-style query using NOT EXISTS)
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT P.Pnumber
    FROM PROJECT P
    WHERE P.Dnum = 15
      AND NOT EXISTS (
          SELECT 1
          FROM WORKS_ON W
          WHERE W.Essn = E.Ssn
            AND W.Pno = P.Pnumber
      )
);

-- --------------------------------------------------------

-- Q3: List project numbers that involve an employee
--     whose last name is 'Smith'
--     (either as a worker OR as a department manager)

-- Part A: Smith works on the project
SELECT DISTINCT W.Pno
FROM EMPLOYEE E
JOIN WORKS_ON W ON E.Ssn = W.Essn
WHERE E.Lname = 'Smith'

UNION

-- Part B: Smith manages the department that controls the project
SELECT DISTINCT P.Pnumber
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.Ssn = D.Mgr_ssn
JOIN PROJECT P ON D.Dnumber = P.Dnum
WHERE E.Lname = 'Smith';