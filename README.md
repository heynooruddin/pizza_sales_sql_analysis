# Pizza Sales SQL Analysis
## Business problem
Analysed pizza orders for a pizza restaurant chain to understand revenue, best-selling products and ordering patterns.
## Dataset
4 tables: orders, order_details, pizzas, pizza_types
(21,350 orders, 21,350 order lines)
## Tools
MySQL 8, MySQL Workbench
## Key questions answered
1. Total orders and total revenue
2. Highest-priced pizza and most common size
3. Top pizza types by quantity and by revenue
4. Orders by hour and average pizzas per day
5. Revenue share per pizza type, cumulative revenue over time
## Key findings
- Most common pizza sized ordered
- Top 5 most ordered pizza types
- Total quantity of each pizza ordered
- Cumulative revenue generated over time
## SQL concepts used
Joins, GROUP BY, aggregate functions, subqueries, derived tables,
window functions, date and time functions
## How to run
Run scripts/01_create_tables.sql, import the CSV files, then
run scripts/02_analysis_queries.sql
