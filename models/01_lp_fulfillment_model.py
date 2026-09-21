import urllib
import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine
from pulp import LpProblem, LpMinimize, LpVariable, lpSum, LpStatus, value, PULP_CBC_CMD


def get_db_engine():
    """Establish robust SQLAlchemy engine connection for SQL Server."""
    connection_string = (
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=AMR\\SQLEXPRESS;"
        "Database=SupplyChainOpt;"
        "Trusted_Connection=yes;"
    )
    params = urllib.parse.quote_plus(connection_string)
    return create_engine(f"mssql+pyodbc:///?odbc_connect={params}")


def load_data(engine):
    """Extract shipping matrix and customer demand from SQL Server."""
    query_routes = """
                   SELECT w.warehouse_id, \
                          w.warehouse_name, \
                          sc.destination_city                                    AS customer_city, \
                          p.product_id, \
                          p.product_name, \
                          wi.available_stock, \
                          (sc.shipping_cost_per_unit + wi.holding_cost_per_unit) AS total_unit_cost
                   FROM ShippingCosts sc
                            JOIN Warehouses w ON sc.warehouse_id = w.warehouse_id
                            JOIN WarehouseInventory wi ON w.warehouse_id = wi.warehouse_id
                            JOIN Products p ON wi.product_id = p.product_id; \
                   """
    df_routes = pd.read_sql(query_routes, engine)

    query_demand = """
                   SELECT customer_city, product_id, required_quantity AS demand
                   FROM CustomerOrders; \
                   """
    df_demand = pd.read_sql(query_demand, engine)

    return df_routes, df_demand


def save_results_to_sql(df_results, engine):
    """Save the optimal fulfillment plan back to SQL Server."""
    print("--- Saving Optimal Results to SQL Server ---")
    df_results.to_sql('OptimalFulfillmentPlan', con=engine, if_exists='append', index=False)
    print("Results successfully inserted into 'OptimalFulfillmentPlan' table.\n")


def generate_visual_chart(df_results):
    """Generate and save visual bar chart of route costs."""
    print("--- Generating Visual Analytics Chart ---")
    plt.figure(figsize=(10, 6))

    # Create route label
    df_results['route'] = 'W' + df_results['warehouse_id'].astype(str) + ' -> ' + df_results['customer_city']

    plt.bar(df_results['route'], df_results['total_cost'], color='#2b5c8f')
    plt.title('Cost Allocation per Fulfillment Route (Optimal Plan)', fontsize=14, fontweight='bold')
    plt.xlabel('Fulfillment Route (Warehouse -> City)', fontsize=11)
    plt.ylabel('Total Cost (EGP)', fontsize=11)
    plt.xticks(rotation=45)
    plt.tight_layout()

    chart_path = 'docs/optimal_cost_distribution.png'
    plt.savefig(chart_path, dpi=300)
    print(f"Chart successfully saved to '{chart_path}'.\n")


def solve_optimization():
    engine = get_db_engine()
    print("--- Loading Data from SQL Server ---")
    df_routes, df_demand = load_data(engine)

    warehouses = df_routes['warehouse_id'].unique()
    cities = df_routes['customer_city'].unique()
    products = df_routes['product_id'].unique()

    costs = df_routes.set_index(['warehouse_id', 'customer_city', 'product_id'])['total_unit_cost'].to_dict()
    stocks = df_routes.groupby(['warehouse_id', 'product_id'])['available_stock'].first().to_dict()
    demands = df_demand.set_index(['customer_city', 'product_id'])['demand'].to_dict()

    model = LpProblem("Multi_Warehouse_Fulfillment_Optimization", LpMinimize)

    ship_vars = {
        (w, c, p): LpVariable(f"Ship_{w}_{c}_{p}", lowBound=0, cat='Integer')
        for w in warehouses for c in cities for p in products
        if (w, c, p) in costs
    }

    model += lpSum(ship_vars[w, c, p] * costs[w, c, p] for w, c, p in ship_vars)

    for (c, p), req_demand in demands.items():
        model += lpSum(ship_vars[w, c, p] for w in warehouses if (w, c, p) in ship_vars) == req_demand

    for (w, p), avail_stock in stocks.items():
        model += lpSum(ship_vars[w, c, p] for c in cities if (w, c, p) in ship_vars) <= avail_stock

    print("--- Solving Linear Programming Model ---")
    model.solve(PULP_CBC_CMD(msg=False))

    print(f"Optimization Status: {LpStatus[model.status]}")
    print(f"Optimal Total Operational Cost = {value(model.objective):,.2f} EGP\n")

    results = []
    for (w, c, p), var in ship_vars.items():
        units = var.varValue
        if units and units > 0:
            unit_cost = costs[w, c, p]
            total_route_cost = units * unit_cost
            results.append({
                'warehouse_id': int(w),
                'customer_city': c,
                'product_id': int(p),
                'shipped_units': int(units),
                'unit_cost': float(unit_cost),
                'total_cost': float(total_route_cost)
            })

    df_results = pd.DataFrame(results)

    # Save to SQL & Generate Chart
    save_results_to_sql(df_results, engine)
    generate_visual_chart(df_results)


if __name__ == "__main__":
    solve_optimization()