-- ====================================================================
-- Objective: Create table to hold optimization run outputs.
-- ====================================================================
USE SupplyChainOpt;
GO

IF OBJECT_ID('dbo.OptimalFulfillmentPlan', 'U') IS NOT NULL DROP TABLE dbo.OptimalFulfillmentPlan;
CREATE TABLE OptimalFulfillmentPlan (
    plan_id INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_id INT NOT NULL,
    customer_city VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    shipped_units INT NOT NULL,
    unit_cost DECIMAL(8,2) NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
GO