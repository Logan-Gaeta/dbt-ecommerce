-- Mart: one row per customer with lifetime order aggregates.
-- Cancelled orders excluded from spend/order counts (they never converted).

with customers as (
    select * from {{ ref('stg_customers') }}
),

order_stats as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(*) as total_orders,
        sum(line_total) as total_spent
    from {{ ref('stg_orders') }}
    where status != 'cancelled'
    group by customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date,
    c.region,
    c.customer_segment,
    o.first_order_date,
    o.last_order_date,
    coalesce(o.total_orders, 0) as total_orders,
    coalesce(o.total_spent, 0) as total_spent
from customers c
left join order_stats o on c.customer_id = o.customer_id
