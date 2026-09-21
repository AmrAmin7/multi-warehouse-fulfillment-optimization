# Multi-Warehouse Supply Chain & Fulfillment Optimization

![SQL Server](https://img.shields.io/badge/Database-SQL_Server-blue?style=flat&logo=microsoftsqlserver)
![Python](https://img.shields.io/badge/Language-Python_3.11+-yellow?style=flat&logo=python)
![Operations Research](https://img.shields.io/badge/Field-Operations_Research_(MILP)-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Executive Summary
This project delivers an end-to-end Operations Research (OR) and Analytics Engineering solution designed to minimize supply chain logistics and order fulfillment costs for a multi-regional e-commerce network. 

By integrating **Microsoft SQL Server (T-SQL)** for relational data management, **Python (SQLAlchemy/pandas)** for data pipeline processing, and **PuLP** for Mixed-Integer Linear Programming (MILP), the system solves complex stock allocation and shipping route choices subject to real-world warehouse capacities and demand constraints.

---

## 🎯 Business Problem & Scenario
An e-commerce enterprise operates across 3 regional distribution hubs (**Cairo**, **Alexandria**, **Giza**) supplying demand across multiple governorates (**Cairo**, **Giza**, **Alexandria**, **Mansoura**, **Aswan**). 

Shipping costs vary dynamically by route distance, while each warehouse incurs distinct inventory holding costs per unit. Unoptimized fulfillment risks over-shipping from high-cost hubs or causing stockouts.

### Key Objectives:
1. **Minimize Total Logistics Cost:** Minimize the joint cost of freight transportation and inventory holding.
2. **Guarantee Demand Satisfaction:** Fulfill 100% of customer order quantities across all destinations.
3. **Respect Inventory Constraints:** Ensure dispatched quantities do not exceed available stock at any regional warehouse.

---

## 🧮 Mathematical Model Formulation (MILP)

The core optimization problem is modeled as a **Mixed-Integer Linear Programming (MILP)** problem:

### **Decision Variables:**
Let $X_{w, c, p}$ be the integer number of units of product $p$ shipped from warehouse $w$ to customer city $c$.

### **Objective Function:**
$$\text{Minimize } Z = \sum_{w} \sum_{c} \sum_{p} X_{w, c, p} \times (\text{ShippingCost}_{w,c} + \text{HoldingCost}_{w,p})$$

### **Constraints:**
1. **Demand Constraint:** Total shipped units of product $p$ to city $c$ must equal customer demand:
   $$\sum_{w} X_{w, c, p} = \text{Demand}_{c, p} \quad \forall c, p$$
2. **Inventory Supply Constraint:** Total units dispatched from warehouse $w$ cannot exceed available stock:
   $$\sum_{c} X_{w, c, p} \le \text{AvailableStock}_{w, p} \quad \forall w, p$$
3. **Non-Negativity & Integrality:**
   $$X_{w, c, p} \in \mathbb{Z}^+ \cup \{0\}$$

---

## 📊 Optimization Results & Analytics Summary

* **Optimal Operational Total Cost:** **`7,459.00 EGP`**
* **Fulfillment Optimization Status:** **Optimal Solution Found (0% Gap)**

### **Optimal Shipping Route Allocation:**

| Origin Warehouse | Destination City | Product | Shipped Units | Unit Cost (EGP) | Total Route Cost (EGP) |
| :--- | :--- | :--- | :---: | :---: | :---: |
| **Cairo Hub (W1)** | Aswan | Laptop Pro 14 (101) | 40 | 65.00 | 2,600.00 |
| **Cairo Hub (W1)** | Cairo | Laptop Pro 14 (101) | 100 | 15.00 | 1,500.00 |
| **Cairo Hub (W1)** | Cairo | Executive Desk (102) | 15 | 25.00 | 375.00 |
| **Cairo Hub (W1)** | Mansoura | Executive Desk (102) | 5 | 40.00 | 200.00 |
| **Alexandria FC (W2)** | Alexandria | Laptop Pro 14 (101) | 60 | 12.50 | 750.00 |
| **Alexandria FC (W2)** | Mansoura | Executive Desk (102) | 20 | 38.00 | 760.00 |
| **Giza Depot (W3)** | Giza | 27-inch Monitor (103) | 70 | 18.20 | 1,274.00 |

> **Visual Asset:** The visual route cost breakdown chart is automatically generated and exported to `docs/optimal_cost_distribution.png`.

---

## 🛠️ Repository Architecture & Tech Stack

```text
multi-warehouse-fulfillment-optimization/
├── README.md                          
├── database/
│   ├── 01_schema.sql                  
│   ├── 02_seed_data.sql               
│   ├── 03_extraction_query.sql        
│   └── 04_save_results.sql            
├── models/
│   └── 01_lp_fulfillment_model.py     
└── docs/
    └── optimal_cost_distribution.png   