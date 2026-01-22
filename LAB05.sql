/*
==========================================================
LAB05 : NSF Grants Database
DBMS / SQL Lab Assignment
----------------------------------------------------------
Problem Context:
This database models an NSF-style research funding system
with organizations, researchers, programs, managers,
grants, and research fields.

The lab focuses on advanced SQL concepts:
- Un-nesting subqueries using JOINs
- Temporary tables
- Self-joins
- Aggregation and GROUP BY
- Multi-year pattern analysis
==========================================================
*/

-- --------------------------------------------------------
-- 1. DATABASE SETUP
-- --------------------------------------------------------
DROP DATABASE IF EXISTS LAB05;
CREATE DATABASE LAB05;
USE LAB05;

-- --------------------------------------------------------
-- 2. CORE TABLES
-- --------------------------------------------------------

-- Organizations receiving grants
CREATE TABLE orgs (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    streetaddr VARCHAR(200),
    city VARCHAR(100),
    state CHAR(2),
    zip CHAR(5),
    phone CHAR(10)
);

-- Researchers working at organizations
CREATE TABLE researchers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    org INT,
    FOREIGN KEY (org) REFERENCES orgs(id)
);

-- NSF programs (each belongs to a directorate)
CREATE TABLE programs (
    id INT PRIMARY KEY,
    name VARCHAR(200),
    directorate CHAR(3)
);

-- NSF program managers
CREATE TABLE managers (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Grants awarded by NSF
CREATE TABLE grants (
    id INT PRIMARY KEY,
    title VARCHAR(300),
    amount DECIMAL(12,2),
    startdate DATE,
    org INT,
    program INT,
    manager INT,
    FOREIGN KEY (org) REFERENCES orgs(id),
    FOREIGN KEY (program) REFERENCES programs(id),
    FOREIGN KEY (manager) REFERENCES managers(id)
);

-- Relationship between grants and researchers
CREATE TABLE grant_researchers (
    grantid INT,
    researcherid INT,
    PRIMARY KEY (grantid, researcherid),
    FOREIGN KEY (grantid) REFERENCES grants(id),
    FOREIGN KEY (researcherid) REFERENCES researchers(id)
);

-- Research fields (high-level topic areas)
CREATE TABLE fields (
    id INT PRIMARY KEY,
    name VARCHAR(200)
);

-- Relationship between grants and fields
CREATE TABLE grant_fields (
    grantid INT,
    fieldid INT,
    PRIMARY KEY (grantid, fieldid),
    FOREIGN KEY (grantid) REFERENCES grants(id),
    FOREIGN KEY (fieldid) REFERENCES fields(id)
);

-- --------------------------------------------------------
-- 3. INSERT SAMPLE DATA (≥ 7 ROWS PER TABLE)
-- --------------------------------------------------------

INSERT INTO orgs VALUES
(1,'MIT','77 Mass Ave','Cambridge','MA','02139','6172531000'),
(2,'Stanford','450 Serra Mall','Stanford','CA','94305','6507232300'),
(3,'Harvard','Mass Ave','Cambridge','MA','02138','6174951000'),
(4,'UC Berkeley','Oxford St','Berkeley','CA','94720','5106426000'),
(5,'CMU','Forbes Ave','Pittsburgh','PA','15213','4122682000'),
(6,'Princeton','Nassau St','Princeton','NJ','08544','6092583000'),
(7,'UIUC','Green St','Urbana','IL','61801','2173331000');

INSERT INTO researchers VALUES
(1,'Alice',1),
(2,'Bob',1),
(3,'Charlie',2),
(4,'David',3),
(5,'Eva',4),
(6,'Frank',5),
(7,'Grace',1);

INSERT INTO programs VALUES
(1,'AI Research','CSE'),
(2,'Bio Systems','BIO'),
(3,'Physics Core','PHY'),
(4,'Math Theory','MTH'),
(5,'Robotics','ENG'),
(6,'Data Science','CSE'),
(7,'Neuroscience','BIO');

INSERT INTO managers VALUES
(1,'Manager A'),
(2,'Manager B'),
(3,'Manager C'),
(4,'Manager D'),
(5,'Manager E'),
(6,'Manager F'),
(7,'Manager G');

INSERT INTO fields VALUES
(1,'Computer Science'),
(2,'Biology'),
(3,'Physics'),
(4,'Mathematics'),
(5,'Robotics'),
(6,'Neuroscience'),
(7,'Data Science');

INSERT INTO grants VALUES
(1,'AI for Health',600000,'2019-01-01',1,1,1),
(2,'AI for Health',700000,'2021-01-01',1,1,1),
(3,'Brain Study',800000,'2019-01-01',1,7,2),
(4,'Brain Study',900000,'2021-01-01',1,7,2),
(5,'Robotics Lab',500000,'2020-01-01',2,5,3),
(6,'Quantum Physics',1200000,'2019-01-01',3,3,4),
(7,'Quantum Physics',1300000,'2021-01-01',3,3,4);

INSERT INTO grant_researchers VALUES
(1,1),
(2,1),
(3,2),
(4,2),
(5,3),
(6,4),
(7,4);

INSERT INTO grant_fields VALUES
(1,1),(1,7),
(2,1),(2,6),
(3,2),(3,6),
(4,2),
(5,5),
(6,3),(6,4),
(7,3),(7,4);

-- ========================================================
-- 4. QUERIES DISCUSSED IN LAB (Q3 – Q8)
-- ========================================================

-- Q3: Un-nest an IN subquery using JOIN
SELECT DISTINCT g.title
FROM grants g
JOIN grant_researchers gr ON g.id = gr.grantid
JOIN researchers r ON gr.researcherid = r.id
WHERE r.name LIKE 'A%';

-- --------------------------------------------------------

-- Q4: Organizations that received the same number of grants
--     for 3 consecutive years
CREATE TEMPORARY TABLE org_year_counts AS
SELECT org, YEAR(startdate) AS yr, COUNT(*) AS grant_count
FROM grants
GROUP BY org, YEAR(startdate)
HAVING COUNT(*) >= 1;

SELECT o.name, y1.grant_count, y1.yr, y2.yr, y3.yr
FROM org_year_counts y1
JOIN org_year_counts y2 ON y1.org=y2.org AND y2.yr=y1.yr+1
JOIN org_year_counts y3 ON y1.org=y3.org AND y3.yr=y1.yr+2
JOIN orgs o ON o.id=y1.org
WHERE y1.grant_count=y2.grant_count
  AND y2.grant_count=y3.grant_count;

-- --------------------------------------------------------

-- Q5: Researchers who received grants from ≥ 2 directorates
SELECT r.name, COUNT(DISTINCT p.directorate) AS directorates
FROM researchers r
JOIN grant_researchers gr ON r.id=gr.researcherid
JOIN grants g ON gr.grantid=g.id
JOIN programs p ON g.program=p.id
GROUP BY r.id, r.name
HAVING COUNT(DISTINCT p.directorate) >= 2
ORDER BY directorates DESC;

-- --------------------------------------------------------

-- Q6: Managers who gave the most money to a single organization
SELECT m.name AS manager, o.name AS organization, SUM(g.amount) AS total_amount
FROM grants g
JOIN managers m ON g.manager=m.id
JOIN orgs o ON g.org=o.id
GROUP BY g.manager, g.org
ORDER BY total_amount DESC
LIMIT 5;

-- --------------------------------------------------------

-- Q7: Top 5 pairs of fields that share the most grants
SELECT f1.name AS field1, f2.name AS field2, COUNT(*) AS shared_grants
FROM grant_fields gf1
JOIN grant_fields gf2
  ON gf1.grantid=gf2.grantid AND gf1.fieldid < gf2.fieldid
JOIN fields f1 ON gf1.fieldid=f1.id
JOIN fields f2 ON gf2.fieldid=f2.id
GROUP BY gf1.fieldid, gf2.fieldid
ORDER BY shared_grants DESC
LIMIT 5;

-- --------------------------------------------------------

-- Q8: MIT researchers who received:
--     > $1M in one year,
--     no grants the next year,
--     > $1M again in the third year
CREATE TEMPORARY TABLE yearly_totals AS
SELECT r.id, r.name, YEAR(g.startdate) AS yr, SUM(g.amount) AS total
FROM researchers r
JOIN grant_researchers gr ON r.id=gr.researcherid
JOIN grants g ON gr.grantid=g.id
JOIN orgs o ON r.org=o.id
WHERE o.name='MIT'
GROUP BY r.id, r.name, YEAR(g.startdate);

SELECT DISTINCT y1.name
FROM yearly_totals y1
JOIN yearly_totals y3
  ON y1.id=y3.id AND y3.yr=y1.yr+2
LEFT JOIN yearly_totals y2
  ON y1.id=y2.id AND y2.yr=y1.yr+1
WHERE y1.total > 1000000
  AND y3.total > 1000000
  AND (y2.total IS NULL OR y2.total = 0);
