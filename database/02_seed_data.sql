-- Populate Warehouses (3 Regional Hubs)
INSERT INTO Warehouses (warehouse_id, warehouse_name, city, max_capacity_units) VALUES
(1, 'Cairo Logistics Hub', 'Cairo', 5000),
(2, 'Alexandria Fulfillment Center', 'Alexandria', 3500),
(3, 'Giza Central Depot', 'Giza', 4000);

-- Populate Products
INSERT INTO Products (product_id, product_name, category, unit_weight_kg) VALUES
(101, 'Laptop Pro 14', 'Electronics', 1.80),
(102, 'Executive Desk', 'Furniture', 35.00),
(103, '27-inch Monitor', 'Electronics', 5.50);

-- Populate Inventory & Unit Holding Costs
INSERT INTO WarehouseInventory (warehouse_id, product_id, available_stock, holding_cost_per_unit) VALUES
-- Cairo Stock
(1, 101, 150, 5.00),
(1, 102, 40, 15.00),
(1, 103, 100, 8.00),
-- Alexandria Stock
(2, 101, 80, 4.50),
(2, 102, 20, 18.00),
(2, 103, 60, 7.50),
-- Giza Stock
(3, 101, 120, 4.80),
(3, 102, 35, 14.50),
(3, 103, 90, 8.20);

-- Populate Shipping Costs Matrix (Freight per Unit)
INSERT INTO ShippingCosts (warehouse_id, destination_city, shipping_cost_per_unit) VALUES
-- Cairo Warehouse to Destinations
(1, 'Cairo', 10.00),
(1, 'Giza', 15.00),
(1, 'Alexandria', 35.00),
(1, 'Mansoura', 25.00),
(1, 'Aswan', 60.00),
-- Alexandria Warehouse to Destinations
(2, 'Cairo', 35.00),
(2, 'Giza', 40.00),
(2, 'Alexandria', 8.00),
(2, 'Mansoura', 20.00),
(2, 'Aswan', 80.00),
-- Giza Warehouse to Destinations
(3, 'Cairo', 15.00),
(3, 'Giza', 10.00),
(3, 'Alexandria', 40.00),
(3, 'Mansoura', 30.00),
(3, 'Aswan', 65.00);

-- Populate Customer Demand Orders
INSERT INTO CustomerOrders (order_id, customer_city, product_id, required_quantity) VALUES
(5001, 'Cairo', 101, 100),
(5002, 'Alexandria', 101, 60),
(5003, 'Mansoura', 102, 25),
(5004, 'Giza', 103, 70),
(5005, 'Aswan', 101, 40),
(5006, 'Cairo', 102, 15);