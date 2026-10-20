-- Mart: one row per product with demand aggregates (non-cancelled orders only).

with products as (
    select * from {{ ref('stg_products') }}
),

demand as (
    select
        product_id,
        count(*) as times_ordered,
        sum(quantity) as units_sold,
        sum(line_total) as total_revenue
    from {{ ref('stg_orders') }}
    where status != 'cancelled'
    group by product_id
)

select
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    coalesce(d.times_ordered, 0) as times_ordered,
    coalesce(d.units_sold, 0) as units_sold,
    coalesce(d.total_revenue, 0) as total_revenue
from products p
left join demand d on p.product_id = d.product_id
