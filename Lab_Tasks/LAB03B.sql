/*
==========================================================
LAB03B : Traveller – Bus – Company – Booking Database
DBMS / SQL Lab Assignment
----------------------------------------------------------
Problem Context:
This database models a bus reservation system involving:
- Travellers
- Bus companies
- Buses scheduled on dates
- Bookings made by travellers

The lab focuses on:
- Joins
- Subqueries (EXISTS / NOT EXISTS)
- Date & time filtering
- Set-based logic
- Foreign key integrity

All queries below correspond to typical DBMS lab questions.
==========================================================
*/

-- --------------------------------------------------------
-- 1. DATABASE SETUP
-- --------------------------------------------------------
DROP DATABASE IF EXISTS LAB03B;
CREATE DATABASE LAB03B;
USE LAB03B;

-- --------------------------------------------------------
-- 2. TRAVELLER TABLE
-- --------------------------------------------------------
CREATE TABLE Traveller (
    Trevid INT PRIMARY KEY,
    Tname VARCHAR(50),
    Tgender VARCHAR(10),
    Tcity VARCHAR(30)
);

-- --------------------------------------------------------
-- 3. COMPANY TABLE
-- --------------------------------------------------------
CREATE TABLE Company (
    cid INT PRIMARY KEY,
    cname VARCHAR(50),
    ccity VARCHAR(30)
);

-- --------------------------------------------------------
-- 4. BUS TABLE
-- Composite primary key (Bid, Bdate)
-- --------------------------------------------------------
CREATE TABLE Bus (
    Bid INT,
    Bdate DATE,
    time TIME,
    src VARCHAR(30),
    dest VARCHAR(30),
    PRIMARY KEY (Bid, Bdate)
);

-- --------------------------------------------------------
-- 5. BOOKING TABLE
-- --------------------------------------------------------
CREATE TABLE Booking (
    Trevid INT,
    cid INT,
    Bid INT,
    Bdate DATE,
    FOREIGN KEY (Trevid) REFERENCES Traveller(Trevid),
    FOREIGN KEY (cid) REFERENCES Company(cid),
    FOREIGN KEY (Bid, Bdate) REFERENCES Bus(Bid, Bdate)
);

-- --------------------------------------------------------
-- 6. INSERT DATA : TRAVELLERS
-- --------------------------------------------------------
INSERT INTO Traveller VALUES
(123,'Amit','Male','Nagpur'),
(156,'Rohit','Male','Mumbai'),
(201,'Rahul','Male','Pune'),
(202,'Neha','Female','Mumbai'),
(203,'Ankit','Male','Delhi'),
(204,'Priya','Female','Nagpur'),
(205,'Suresh','Male','Chennai'),
(206,'Kiran','Male','Bangalore'),
(207,'Pooja','Female','Hyderabad'),
(208,'Aakash','Male','Indore'),
(209,'Meena','Female','Jaipur'),
(210,'Vikas','Male','Surat'),
(211,'Ritu','Female','Ahmedabad'),
(212,'Aman','Male','Kolkata'),
(213,'Snehal','Female','Pune'),
(214,'Nikhil','Male','Mumbai'),
(215,'Divya','Female','Delhi');

-- --------------------------------------------------------
-- 7. INSERT DATA : COMPANIES
-- --------------------------------------------------------
INSERT INTO Company VALUES
(1,'Kingfisher','Nagpur'),
(2,'Volvo','Mumbai'),
(3,'RedBus','Bangalore'),
(4,'Orange Travels','Nagpur'),
(5,'Neeta Travels','Pune'),
(6,'SRS','Bangalore'),
(7,'VRL','Hubli'),
(8,'KSRTC','Bangalore'),
(9,'MSRTC','Mumbai'),
(10,'GSRTC','Ahmedabad'),
(11,'UPSRTC','Lucknow'),
(12,'APSRTC','Hyderabad'),
(13,'TSRTC','Hyderabad'),
(14,'TNSTC','Chennai'),
(15,'RSRTC','Jaipur'),
(16,'WBTC','Kolkata'),
(17,'BEST','Mumbai');

-- --------------------------------------------------------
-- 8. INSERT DATA : BUS SCHEDULES
-- --------------------------------------------------------
INSERT INTO Bus VALUES
(10,'2020-11-05','15:00','Nagpur','Chennai'),
(11,'2020-12-01','16:00','Delhi','Mumbai'),
(20,'2020-11-01','08:00','Pune','Mumbai'),
(21,'2020-11-02','09:30','Nagpur','Delhi'),
(22,'2020-11-03','16:00','Delhi','Mumbai'),
(23,'2020-11-04','22:00','Mumbai','Pune'),
(24,'2020-11-05','06:00','Chennai','Bangalore'),
(25,'2020-11-06','16:00','Nagpur','Mumbai'),
(26,'2020-11-07','14:00','Indore','Jaipur'),
(27,'2020-12-01','16:00','Delhi','Mumbai'),
(27,'2020-12-02','16:00','Delhi','Mumbai'),
(28,'2020-12-01','10:00','Pune','Goa'),
(29,'2020-12-02','10:00','Pune','Goa'),
(30,'2020-10-10','12:00','Nagpur','Lucknow'),
(31,'2020-10-11','18:00','Hyderabad','Chennai'),
(32,'2020-10-12','07:00','Surat','Ahmedabad'),
(33,'2020-10-13','21:00','Kolkata','Delhi');

-- --------------------------------------------------------
-- 9. INSERT DATA : BOOKINGS
-- --------------------------------------------------------
INSERT INTO Booking VALUES
(123,1,11,'2020-12-01'),
(156,1,10,'2020-11-05'),
(201,5,20,'2020-11-01'),
(202,9,23,'2020-11-04'),
(203,2,21,'2020-11-02'),
(204,4,25,'2020-11-06'),
(205,14,24,'2020-11-05'),
(206,3,22,'2020-11-03'),
(207,12,31,'2020-10-11'),
(208,10,32,'2020-10-12'),
(209,15,26,'2020-11-07'),
(210,17,23,'2020-11-04'),
(211,10,32,'2020-10-12'),
(212,16,33,'2020-10-13'),
(213,5,28,'2020-12-01'),
(214,17,20,'2020-11-01'),
(215,2,22,'2020-11-03');

-- ========================================================
-- 10. QUERIES DISCUSSED IN LAB
-- ========================================================

-- Q1: Get complete details of all buses going to Mumbai
SELECT * 
FROM Bus 
WHERE dest = 'Mumbai';

-- Q2: Get details of buses from Nagpur to Lucknow
SELECT * 
FROM Bus
WHERE src = 'Nagpur' AND dest = 'Lucknow';

-- Q3: Bus numbers for passenger 156 going to Chennai before 06-11-2020
SELECT DISTINCT b.Bid
FROM Booking k
JOIN Bus b ON k.Bid = b.Bid AND k.Bdate = b.Bdate
WHERE k.Trevid = 156
  AND b.dest = 'Chennai'
  AND b.Bdate < '2020-11-06';

-- Q4: Traveller names who have at least one booking
SELECT DISTINCT t.Tname
FROM Traveller t
JOIN Booking b ON t.Trevid = b.Trevid;

-- Q5: Traveller names who have NO bookings
SELECT Tname
FROM Traveller t
WHERE NOT EXISTS (
    SELECT 1 
    FROM Booking b 
    WHERE b.Trevid = t.Trevid
);

-- Q6: Company names located in the same city as passenger with Trevid = 123
SELECT c.cname
FROM Company c
JOIN Traveller t ON c.ccity = t.Tcity
WHERE t.Trevid = 123;

-- Q7: Buses scheduled on BOTH 01-12-2020 and 02-12-2020 at 16:00
SELECT *
FROM Bus b1
WHERE time = '16:00'
  AND Bdate = '2020-12-01'
  AND EXISTS (
      SELECT 1
      FROM Bus b2
      WHERE b2.Bid = b1.Bid
        AND b2.time = '16:00'
        AND b2.Bdate = '2020-12-02'
  );

-- Q8: Buses scheduled on EITHER or BOTH dates at 16:00
SELECT *
FROM Bus
WHERE time = '16:00'
  AND Bdate IN ('2020-12-01','2020-12-02');

-- Q9: Company names with NO bookings for passenger 123
SELECT cname
FROM Company c
WHERE NOT EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.cid = c.cid
      AND b.Trevid = 123
);

-- Q10: Male passengers associated with Kingfisher bus
SELECT DISTINCT t.*
FROM Traveller t
JOIN Booking b ON t.Trevid = b.Trevid
JOIN Company c ON b.cid = c.cid
WHERE t.Tgender = 'Male'
  AND c.cname = 'Kingfisher';
