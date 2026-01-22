# LAB05 – NSF Grants Database (Advanced SQL)

## 📌 Overview
This project implements an **NSF-style research grants database** using **MySQL**.  
It models organizations, researchers, programs, managers, grants, and research fields, and demonstrates **advanced SQL querying techniques** commonly taught in DBMS courses.

The lab focuses on **query formulation, optimization concepts, and complex relational reasoning**, not just schema design.

---

## 🗂️ Database Schema

The database contains the following entities:

- **orgs** – Organizations receiving research grants  
- **researchers** – Researchers affiliated with organizations  
- **programs** – NSF programs grouped by directorates  
- **managers** – Program managers who allocate grants  
- **grants** – Grant records with amount and start date  
- **grant_researchers** – Many-to-many relationship between grants and researchers  
- **fields** – High-level research areas  
- **grant_fields** – Many-to-many relationship between grants and fields  

All relationships are enforced using **foreign key constraints**.

---

## 🎯 Learning Objectives

This lab demonstrates:

- Un-nesting subqueries using **JOINs**
- Use of **temporary tables**
- **Self-joins** for pairwise analysis
- **Aggregate functions** with `GROUP BY` and `HAVING`
- Multi-year pattern analysis using date functions
- Writing **optimizer-friendly SQL**

---

## 📄 Files Included

| File Name | Description |
|----------|------------|
| `lab05.sql` | Complete SQL script: schema creation, data insertion, and queries |
| `README.md` | Project documentation (this file) |

---

## 🛠️ How to Run

1. Open **MySQL Workbench**
2. Open `lab05.sql`
3. Execute the script **from top to bottom**
4. The database `LAB05` will be created automatically
5. All queries (Q3–Q8) will run without errors

---

## 🔍 Queries Implemented

### **Q3. Un-nesting a Subquery**
Rewrites an `IN`-based subquery as a `JOIN` to improve readability and performance.

### **Q4. Organizations with Same Number of Grants for 3 Consecutive Years**
Uses a **temporary table** and **self-joins** to detect repeating yearly patterns.

### **Q5. Researchers with Grants from Multiple Directorates**
Uses `GROUP BY` and `HAVING` to find researchers funded across multiple NSF directorates.

### **Q6. Managers Allocating the Most Funding to a Single Organization**
Aggregates grant amounts to identify top manager–organization funding relationships.

### **Q7. Multidisciplinary Grant Analysis**
Uses **self-joins** to find pairs of research fields that frequently appear together in grants.

### **Q8. Complex Multi-Year Grant Pattern (Hard)**
Identifies MIT researchers who:
- received more than $1M in one year,
- received no grants the following year,
- then again received more than $1M in the third year.

This query uses **temporary tables** and multi-year joins for efficiency.

---

## 🧠 Key SQL Concepts Used

- `JOIN`, `LEFT JOIN`
- `EXISTS` / `NOT EXISTS`
- `GROUP BY`, `HAVING`
- `COUNT`, `SUM`
- `YEAR()` date function
- `UNION`
- Temporary tables (`CREATE TEMPORARY TABLE`)
- Composite and foreign keys

---

## ✅ Notes for Evaluation

- All queries are **MySQL-compatible**
- The schema and data are **foreign-key safe**
- Queries are written for **clarity and correctness**, not shortcuts
- Sample data is intentionally minimal but sufficient to validate logic

---

## 👨‍🎓 Author
**Jigar**  
B.Tech – Computer Science  
IIIT Nagpur  

---

## 📌 License
This project is intended for **academic use only** as part of a DBMS laboratory course.
