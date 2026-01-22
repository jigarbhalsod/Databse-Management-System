/*
==========================================================
LAB02 : Inventory & Purchase Management System
DBMS / SQL Lab Assignment
----------------------------------------------------------
This database models a simple inventory system with:
- Users (Admin / Manager / Staff)
- Suppliers
- Categories
- Items
- Inventory tracking
- Purchase orders and order details

Key Concepts Used:
- Primary & Foreign Keys
- ENUMs
- Aggregation (SUM)
- JOINs
- Indexing for performance
==========================================================
*/

-- --------------------------------------------------------
-- 1. DATABASE SETUP
-- --------------------------------------------------------
DROP DATABASE IF EXISTS LAB02;
CREATE DATABASE LAB02;
USE LAB02;

-- --------------------------------------------------------
-- 2. USERS TABLE
-- Stores system users and their roles
-- --------------------------------------------------------
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('ADMIN', 'MANAGER', 'STAFF') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 3. SUPPLIERS TABLE
-- Stores supplier details
-- --------------------------------------------------------
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT
);

-- --------------------------------------------------------
-- 4. CATEGORIES TABLE
-- Logical grouping of items
-- --------------------------------------------------------
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- --------------------------------------------------------
-- 5. ITEMS TABLE
-- Each item belongs to a category and supplier
-- --------------------------------------------------------
CREATE TABLE items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    category_id INT,
    supplier_id INT,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- --------------------------------------------------------
-- 6. INVENTORY TABLE
-- Tracks current stock and safe stock levels
-- --------------------------------------------------------
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT UNIQUE,
    quantity INT NOT NULL,
    safe_stock_level INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- --------------------------------------------------------
-- 7. PURCHASE ORDERS TABLE
-- Header information for purchase orders
-- --------------------------------------------------------
CREATE TABLE purchase_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    ordered_by INT,
    order_date DATE NOT NULL,
    status ENUM('PLACED', 'RECEIVED', 'CANCELLED') NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (ordered_by) REFERENCES users(user_id)
);

-- --------------------------------------------------------
-- 8. PURCHASE ORDER DETAILS TABLE
-- Line items for each purchase order
-- --------------------------------------------------------
CREATE TABLE purchase_order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- --------------------------------------------------------
-- 9. SAMPLE DATA INSERTION
-- --------------------------------------------------------

-- Users
INSERT INTO users (name, email, role) VALUES
('Amit Sharma', 'amit@company.com', 'ADMIN'),
('Neha Verma', 'neha@company.com', 'MANAGER'),
('Rohit Kumar', 'rohit@company.com', 'STAFF');

-- Suppliers
INSERT INTO suppliers (supplier_name, phone, email, address) VALUES
('ABC Traders', '9876543210', 'abc@traders.com', 'Delhi'),
('Global Supplies', '9123456780', 'contact@global.com', 'Mumbai'),
('TechSource Pvt Ltd', '9988776655', 'sales@techsource.com', 'Bangalore');

-- Categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Stationery'),
('Furniture');

-- Items
INSERT INTO items (item_name, category_id, supplier_id, unit_price) VALUES
('Laptop', 1, 3, 55000.00),
('Printer', 1, 1, 12000.00),
('Notebook', 2, 2, 50.00),
('Office Chair', 3, 1, 4500.00);

-- Inventory
INSERT INTO inventory (item_id, quantity, safe_stock_level) VALUES
(1, 15, 10),
(2, 5, 8),
(3, 500, 200),
(4, 7, 5);

-- Purchase Orders
INSERT INTO purchase_orders (supplier_id, ordered_by, order_date, status) VALUES
(1, 2, '2025-01-10', 'PLACED'),
(2, 2, '2025-01-12', 'RECEIVED');

-- Purchase Order Details
INSERT INTO purchase_order_details (order_id, item_id, quantity, cost_price) VALUES
(1, 2, 10, 11000.00),
(1, 4, 5, 4300.00),
(2, 3, 300, 45.00);

-- --------------------------------------------------------
-- 10. QUERIES DISCUSSED IN LAB
-- --------------------------------------------------------

-- Q1: Find items below safe stock level
SELECT 
    i.item_name,
    inv.quantity,
    inv.safe_stock_level
FROM inventory inv
JOIN items i ON inv.item_id = i.item_id
WHERE inv.quantity < inv.safe_stock_level;

-- Q2: Calculate total inventory value
SELECT 
    SUM(inv.quantity * i.unit_price) AS total_inventory_value
FROM inventory inv
JOIN items i ON inv.item_id = i.item_id;

-- Q3: Total purchase cost per supplier
SELECT 
    s.supplier_name,
    SUM(pod.quantity * pod.cost_price) AS total_cost
FROM suppliers s
JOIN purchase_orders po ON s.supplier_id = po.supplier_id
JOIN purchase_order_details pod ON po.order_id = pod.order_id
GROUP BY s.supplier_name;

-- --------------------------------------------------------
-- 11. INDEXING FOR PERFORMANCE
-- --------------------------------------------------------
CREATE INDEX idx_item_name ON items(item_name);
CREATE INDEX idx_inventory_quantity ON inventory(quantity);
CREATE INDEX idx_order_date ON purchase_orders(order_date);
