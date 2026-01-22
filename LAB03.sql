/*
==========================================================
LAB03 : Supplier–Computer–Catalog Database
DBMS / SQL Lab Assignment
----------------------------------------------------------
Problem Context:
This database models suppliers who supply different computers.
Using this schema, we answer classic relational queries such as:
- Suppliers supplying specific brands
- OR / AND conditions
- Division queries ("supplies ALL computers")
- Brand-based constraints

Key Concepts Used:
- Primary & Foreign Keys
- JOINs
- UNION
- GROUP BY / HAVING
- Division-style queries
==========================================================
*/

-- --------------------------------------------------------
-- 1. DATABASE SETUP
-- --------------------------------------------------------
DROP DATABASE IF EXISTS LAB03;
CREATE DATABASE LAB03;
USE LAB03;

-- --------------------------------------------------------
-- 2. SUPPLIERS TABLE
-- --------------------------------------------------------
CREATE TABLE Suppliers (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    address VARCHAR(50)
);

-- --------------------------------------------------------
-- 3. COMPUTER TABLE
-- --------------------------------------------------------
CREATE TABLE Computer (
    cid INT PRIMARY KEY,
    cname VARCHAR(50),
    brand VARCHAR(30)
);

-- --------------------------------------------------------
-- 4. CATALOG TABLE (Relationship between Supplier & Computer)
-- --------------------------------------------------------
CREATE TABLE Catalog (
    sid INT,
    cid INT,
    cost INT,
    PRIMARY KEY (sid, cid),
    FOREIGN KEY (sid) REFERENCES Suppliers(sid),
    FOREIGN KEY (cid) REFERENCES Computer(cid)
);

-- --------------------------------------------------------
-- 5. INSERT DATA : SUPPLIERS (15 rows)
-- --------------------------------------------------------
INSERT INTO Suppliers VALUES
(1,'Ram Traders','Nagpur'),
(2,'Shyam Suppliers','Mumbai'),
(3,'Om Computers','Delhi'),
(4,'TechHub','Pune'),
(5,'Binary Systems','Nagpur'),
(6,'Logic World','Bangalore'),
(7,'NextGen IT','Hyderabad'),
(8,'MicroZone','Chennai'),
(9,'CompStore','Kolkata'),
(10,'ByteMart','Mumbai'),
(11,'Silicon Point','Delhi'),
(12,'DataSys','Ahmedabad'),
(13,'SoftSell','Indore'),
(14,'IT Plaza','Jaipur'),
(15,'CoreTech','Surat');

-- --------------------------------------------------------
-- 6. INSERT DATA : COMPUTERS (15 rows)
-- --------------------------------------------------------
INSERT INTO Computer VALUES
(101,'EliteBook','HP'),
(102,'ThinkPad','Lenovo'),
(103,'Inspiron','Dell'),
(104,'Aspire','Acer'),
(105,'Pavilion','HP'),
(106,'Latitude','Dell'),
(107,'Vostro','Dell'),
(108,'MacBook Air','Apple'),
(109,'MacBook Pro','Apple'),
(110,'IdeaPad','Lenovo'),
(111,'Swift','Acer'),
(112,'Predator','Acer'),
(113,'ZBook','HP'),
(114,'XPS','Dell'),
(115,'Yoga','Lenovo');

-- --------------------------------------------------------
-- 7. INSERT DATA : CATALOG (FK-safe, division-friendly)
-- --------------------------------------------------------
INSERT INTO Catalog VALUES
-- Supplier 1 (supplies many computers)
(1,101,50000),(1,102,52000),(1,103,55000),(1,104,45000),
(1,105,48000),(1,106,56000),(1,107,54000),(1,110,51000),
(1,113,60000),(1,114,65000),

-- Supplier 2
(2,101,51000),(2,103,56000),(2,106,55500),(2,114,66000),

-- Supplier 3
(3,102,53000),(3,104,45000),(3,110,50000),

-- Supplier 4
(4,101,52000),(4,105,49000),(4,113,61000),

-- Supplier 5
(5,101,50500),(5,105,48500),

-- Supplier 6
(6,106,55000),(6,107,54500),(6,114,67000),

-- Supplier 7
(7,110,51500),(7,115,58500),

-- Supplier 8
(8,111,47000),(8,112,72000),

-- Supplier 9
(9,108,90000),(9,109,120000),

-- Supplier 10
(10,103,56000),(10,114,68000),

-- Supplier 11
(11,101,50000),(11,106,55000),

-- Supplier 12
(12,104,46000),

-- Supplier 13
(13,110,52000),

-- Supplier 14
(14,105,49500),

-- Supplier 15
(15,115,59000);

-- ========================================================
-- 8. QUERIES DISCUSSED IN LAB
-- ========================================================

-- Q1: Names of suppliers who supply HP computers
SELECT DISTINCT s.sname
FROM Suppliers s
JOIN Catalog c ON s.sid = c.sid
JOIN Computer p ON c.cid = p.cid
WHERE p.brand = 'HP';

-- Q2: Supplier IDs who supply HP or Lenovo computers
SELECT DISTINCT c.sid
FROM Catalog c
JOIN Computer p ON c.cid = p.cid
WHERE p.brand IN ('HP','Lenovo');

-- Q3: Supplier IDs who supply HP computers OR are located in Nagpur
SELECT sid
FROM Suppliers
WHERE address = 'Nagpur'
UNION
SELECT c.sid
FROM Catalog c
JOIN Computer p ON c.cid = p.cid
WHERE p.brand = 'HP';

-- Q4: Supplier IDs who supply BOTH Acer AND Lenovo computers
-- (INTERSECT rewritten using GROUP BY for MySQL compatibility)
SELECT c.sid
FROM Catalog c
JOIN Computer p ON c.cid = p.cid
WHERE p.brand IN ('Acer','Lenovo')
GROUP BY c.sid
HAVING COUNT(DISTINCT p.brand) = 2;

-- Q5: Supplier IDs who supply EVERY computer (division query)
SELECT sid
FROM Catalog
GROUP BY sid
HAVING COUNT(DISTINCT cid) = (SELECT COUNT(*) FROM Computer);

-- Q6: Supplier IDs who supply EVERY Dell computer
SELECT c.sid
FROM Catalog c
JOIN Computer p ON c.cid = p.cid
WHERE p.brand = 'Dell'
GROUP BY c.sid
HAVING COUNT(DISTINCT c.cid) =
      (SELECT COUNT(*) FROM Computer WHERE brand = 'Dell');

-- Q7: Supplier IDs who supply EVERY HP OR Dell computer
SELECT c.sid
FROM Catalog c
JOIN Computer p ON c.cid = p.cid
WHERE p.brand IN ('HP','Dell')
GROUP BY c.sid
HAVING COUNT(DISTINCT c.cid) =
      (SELECT COUNT(*) FROM Computer WHERE brand IN ('HP','Dell'));
