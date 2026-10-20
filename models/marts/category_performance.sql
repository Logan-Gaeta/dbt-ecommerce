-- Mart: category performance summary. One row per product category.
-- Written by Logan (2026-10-07) — first hand-written model.

with orders as (
    select * from {{ ref('fct_orders') }}
    where status <> 'cancelled'
)

select
    category,
    count(order_id) as total_orders,
    count(distinct customer_id) as unique_customers,
    sum(line_total) as total_revenue,
    round(avg(line_total), 2) as avg_order_value
from orders
group by category
order by total_revenue desc
