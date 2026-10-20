-- Mart: one row per order, enriched with customer + product attributes.
-- Grain: order_id.

with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select customer_id, region, customer_segment from {{ ref('dim_customers') }}
),

products as (
    select product_id, product_name, category from {{ ref('dim_products') }}
)

select
    o.order_id,
    o.order_date,
    o.customer_id,
    c.region,
    c.customer_segment,
    o.product_id,
    p.product_name,
    p.category,
    o.quantity,
    o.unit_price,
    o.discount_pct,
    o.status,
    o.line_total
from orders o
left join customers c on o.customer_id = c.customer_id
left join products p on o.product_id = p.product_id
