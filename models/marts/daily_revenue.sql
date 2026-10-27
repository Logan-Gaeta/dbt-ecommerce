-- Mart: daily revenue summary (aggregate fact on fct_orders).
-- Grain: one row per calendar day. The first thing a dashboard would read.
-- The calendar date comes from dim_date via date_sk, not from a raw date
-- column: month/quarter/weekend logic lives in the dimension.

with orders as (
    select * from {{ ref('fct_orders') }}
    where status != 'cancelled'
),

dates as (
    select date_sk, date_value from {{ ref('dim_date') }}
)

select
    d.date_value as revenue_date,
    count(*) as total_orders,
    count(distinct o.customer_sk) as unique_customers,
    sum(o.line_total) as total_revenue,
    round(avg(o.line_total), 2) as avg_order_value
from orders o
left join dates d on d.date_sk = o.date_sk
group by d.date_value
