-- Mart: daily revenue summary. The first thing a dashboard would read.

with orders as (
    select * from {{ ref('fct_orders') }}
    where status != 'cancelled'
)

select
    order_date as revenue_date,
    count(*) as total_orders,
    count(distinct customer_id) as unique_customers,
    sum(line_total) as total_revenue,
    round(avg(line_total), 2) as avg_order_value
from orders
group by order_date
