-- Staging: normalize order status casing, compute line-level revenue.
-- Cancelled orders are kept here (not filtered) so downstream models decide how to treat them.

with source as (
    select * from {{ ref('raw_orders') }}
)

select
    order_id,
    customer_id,
    product_id,
    cast(order_date as date) as order_date,
    quantity,
    cast(unit_price as decimal(10,2)) as unit_price,
    cast(discount_pct as decimal(5,4)) as discount_pct,
    lower(trim(status)) as status,
    round(quantity * cast(unit_price as decimal(10,2)) * (1 - cast(discount_pct as decimal(5,4))), 2) as line_total
from source
