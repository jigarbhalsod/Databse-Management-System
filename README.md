# 🪙 Space Agency Resource & Funding Management System

## 📌 Overview
A database project that manages space agency departments, employees, projects, and funding allocations — inspired by Indian organizations like **ISRO**.

This system helps track:
- Department-wise projects
- Employee assignments
- Budget utilization
- Funding source management

## 🧱 Database Structure
- Departments
- Employees
- Projects
- Budgets
- Funding Sources

## 🧠 Features
- Insert, update, and query space research data
- Aggregated analysis using `GROUP BY` and `JOIN`
- Triggers for budget log tracking
- Views for easy project management access

## 💡 Example Advanced Feature
```sql
CREATE TRIGGER after_budget_insert
AFTER INSERT ON Budgets
FOR EACH ROW
BEGIN
    INSERT INTO Budget_Log (project_id, amount)
    VALUES (NEW.project_id, NEW.amount);
END;
