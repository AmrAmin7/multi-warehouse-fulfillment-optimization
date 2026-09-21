-- 1. Full Fulfillment Routes & Unit Cost Matrix
-- Combines shipping costs with warehouse unit holding costs
SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.city AS warehouse_city,
    sc.destination_city AS customer_city,
    p.product_id,
    p.product_name,
    p.unit_weight_kg,
    wi.available_stock,
    wi.holding_cost_per_unit,
    sc.shipping_cost_per_unit,
    (sc.shipping_cost_per_unit + wi.holding_cost_per_unit) AS total_unit_cost
FROM ShippingCosts sc
INNER JOIN Warehouses w
    ON sc.warehouse_id = w.warehouse_id
INNER JOIN WarehouseInventory wi
    ON w.warehouse_id = wi.warehouse_id
INNER JOIN Products p
    ON wi.product_id = p.product_id
ORDER BY p.product_id, w.warehouse_id, sc.destination_city;

-- 2. Customer Demand Summary
SELECT
    co.order_id,
    co.customer_city,
    co.product_id,
    p.product_name,
    co.required_quantity AS demand_units
FROM CustomerOrders co
INNER JOIN Products p
    ON co.product_id = p.product_id;