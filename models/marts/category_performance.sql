-- Mart: category performance summary (aggregate fact on fct_orders).
-- Grain: one row per product category per calendar month.
-- Previously one row per category, all-time, which could not trend or
-- compare periods; the month grain fixes that. Category is reached by
-- joining dim_products: the fact holds keys, not attributes.

with orders as (
    select * from {{ ref('fct_orders') }}
    where status <> 'cancelled'
),

products as (
    select product_sk, category from {{ ref('dim_products') }}
),

dates as (
    select date_sk, month_start from {{ ref('dim_date') }}
)

select
    p.category,
    d.month_start as revenue_month,
    count(o.order_id) as total_orders,
    count(distinct o.customer_sk) as unique_customers,
    sum(o.line_total) as total_revenue,
    round(avg(o.line_total), 2) as avg_order_value
from orders o
left join products p on p.product_sk = o.product_sk
left join dates d on d.date_sk = o.date_sk
group by p.category, revenue_month
order by revenue_month, total_revenue desc
