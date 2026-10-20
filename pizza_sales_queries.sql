-- ============================================================
-- Pizza Sales Analysis (MySQL)
-- Tables: orders, order_details, pizzas, pizza_types
-- Joins:  orders -> order_details (order_id)
--         order_details -> pizzas (pizza_id)
--         pizzas -> pizza_types (pizza_type_id)
-- ============================================================


-- 1. Retrieve the total number of orders placed.
select count(order_id) as number_of_orders
from orders;


-- 2. Calculate the total revenue generated from pizza sales.
select sum(order_details.quantity * pizzas.price) as TOTAL_Rev
from order_details
left join pizzas on order_details.pizza_id = pizzas.pizza_id;


-- 3. Identify the highest-priced pizza.
select pizza_types.name, pizzas.size, pizzas.price
from pizza_types
left join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;


-- 4. Identify the most common pizza size ordered.
select pizzas.size, sum(order_details.quantity) as total_quantity
from order_details
left join pizzas on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size
order by total_quantity desc
limit 1;


-- 5. List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, pizza_types.pizza_type_id,
       sum(order_details.quantity) as sumofquantity
from order_details
left join pizzas on order_details.pizza_id = pizzas.pizza_id
left join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.pizza_type_id, pizza_types.name
order by sumofquantity desc
limit 5;


-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as total_quantity
from pizza_types
left join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
left join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by total_quantity desc;


-- 7. Determine the distribution of orders by hour of the day.
select hour(time) as HOURTH, count(order_id) as number_of_orders
from orders
group by HOURTH
order by HOURTH;


-- 8. Join relevant tables to find the category-wise distribution of pizzas.
-- Reading 1: number of pizza types in each category
select count(name), category
from pizza_types
group by category;

-- Reading 2: number of pizza products (type + size) in each category
select count(pizzas.size) as count_of_size, pizza_types.category
from pizzas
left join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category;


-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(total_pizzas) as avg_pizzas_per_day
from (select sum(order_details.quantity) as total_pizzas, orders.date
      from order_details
      left join orders on order_details.order_id = orders.order_id
      group by orders.date) as daily_totals;


-- 10. Determine the top 3 most ordered pizza types based on revenue.
select sum(order_details.quantity * pizzas.price) as revenue, pizza_types.name
from order_details
left join pizzas on order_details.pizza_id = pizzas.pizza_id
left join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by revenue desc
limit 3;


-- 11. Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.name,
       round(sum(pizzas.price*order_details.quantity)*100/
       (select sum(pizzas.price*order_details.quantity)
        from pizzas left join order_details
        on pizzas.pizza_id=order_details.pizza_id), 2) as pct_of_revenue
from pizza_types
left join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
left join order_details on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.pizza_type_id, pizza_types.name
order by pct_of_revenue desc;


-- 12. Analyze the cumulative revenue generated over time.
select date,
       rev_on_dates as daily_revenue,
       sum(rev_on_dates) over (order by date) as cumulative_rev
from (select sum(pizzas.price*order_details.quantity) as Rev_on_Dates,
             orders.date as date
      from order_details
      left join pizzas on pizzas.pizza_id=order_details.pizza_id
      left join orders on order_details.order_id=orders.order_id
      group by orders.date) as daily_rev_table
order by date;
