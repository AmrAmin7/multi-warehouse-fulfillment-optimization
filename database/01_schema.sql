-- ====================================================================
-- Project: Multi-Warehouse Supply Chain Optimization
-- Objective: Create relational schema for warehouses, products, inventory, and orders.
-- ====================================================================
USE master;
GO

-- Create database if it does not exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SupplyChainOpt')
BEGIN
    CREATE DATABASE SupplyChainOpt;
END
GO

USE SupplyChainOpt;
GO

-- 1. Table: Warehouses (المستودعات)
IF OBJECT_ID('dbo.Warehouses', 'U') IS NOT NULL DROP TABLE dbo.Warehouses;
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    max_capacity_units INT NOT NULL
);

-- 2. Table: Products
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_weight_kg DECIMAL(8, 2) NOT NULL
);

-- 3. Table: WarehouseInventory
CREATE TABLE IF NOT EXISTS WarehouseInventory (
    warehouse_id INT,
    product_id INT,
    available_stock INT NOT NULL,
    holding_cost_per_unit DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 4. Table: CustomerOrders (طلبات العملاء والطلب المتوقع)
IF OBJECT_ID('dbo.CustomerOrders', 'U') IS NOT NULL DROP TABLE dbo.CustomerOrders;
CREATE TABLE CustomerOrders (
    order_id INT PRIMARY KEY,
    customer_city VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    required_quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 5. Table: ShippingCosts (مصفوفة أسعار الشحن والتوصيل)
IF OBJECT_ID('dbo.ShippingCosts', 'U') IS NOT NULL DROP TABLE dbo.ShippingCosts;
CREATE TABLE ShippingCosts (
    warehouse_id INT NOT NULL,
    destination_city VARCHAR(50) NOT NULL,
    shipping_cost_per_unit DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (warehouse_id, destination_city),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);