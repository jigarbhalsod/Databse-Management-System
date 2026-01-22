/*
==========================================================
LAB04B : Customer – Item – Orders Database
DBMS / SQL Lab Assignment
----------------------------------------------------------
Problem Context:
This database models a simple ordering system involving:
- Customers
- Items
- Orders placed by customers

The lab focuses on:
- Nested subqueries
- Division-style queries using NOT EXISTS
- Aggregate functions (MAX)
- Foreign key relationships

==========================================================
*/

-- --------------------------------------------------------
-- 1. DATABASE SETUP
-- --------------------------------------------------------
DROP DATABASE IF EXISTS LAB04B;
CREATE DATABASE LAB04B;
USE LAB04B;

-- --------------------------------------------------------
-- 2. CUSTOMER TABLE
-- --------------------------------------------------------
CREATE TABLE Customer (
    cid INT PRIMARY KEY,
    cname VARCHAR(30),
    rating INT,
    salary DECIMAL(10,2)
);

-- --------------------------------------------------------
-- 3. ITEM TABLE
-- --------------------------------------------------------
CREATE TABLE Item (
    iid INT PRIMARY KEY,
    iname VARCHAR(30),
    type VARCHAR(20)
);

-- --------------------------------------------------------
-- 4. ORDERS TABLE
-- (Relationship between Customer and Item)
-- --------------------------------------------------------
CREATE TABLE Orders (
    cid INT,
    iid INT,
    day DATE,
    qty INT,
    FOREIGN KEY (cid) REFERENCES Customer(cid),
    FOREIGN KEY (iid) REFERENCES Item(iid)
);

-- --------------------------------------------------------
-- 5. INSERT DATA : CUSTOMERS
-- --------------------------------------------------------
INSERT INTO Customer VALUES
(1,'Amit',5,50000),
(2,'Rohit',4,80000),
(3,'Sneha',3,80000),
(4,'Kiran',2,45000);

-- --------------------------------------------------------
-- 6. INSERT DATA : ITEMS
-- --------------------------------------------------------
INSERT INTO Item VALUES
(101,'Laptop','Electronics'),
(102,'Phone','Electronics'),
(103,'Tablet','Electronics');

-- --------------------------------------------------------
-- 7. INSERT DATA : ORDERS
-- --------------------------------------------------------
INSERT INTO Orders VALUES
(1,101,'2023-01-01',1),
(1,102,'2023-01-02',1),
(1,103,'2023-01-03',1),
(2,101,'2023-01-04',1),
(2,102,'2023-01-05',1),
(3,101,'2023-01-06',1);

-- ========================================================
-- 8. QUERIES DISCUSSED IN LAB
-- ========================================================

-- Q1: Find the names of customers who have ordered ALL items
-- (Division-style query using NOT EXISTS)
SELECT C.cname
FROM Customer C
WHERE NOT EXISTS (
    SELECT I.iid
    FROM Item I
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders O
        WHERE O.cid = C.cid
          AND O.iid = I.iid
    )
);

-- --------------------------------------------------------

-- Q2: Find the customer name(s) with the HIGHEST salary
-- (Handles ties correctly)
SELECT cname
FROM Customer
WHERE salary = (SELECT MAX(salary) FROM Customer);
