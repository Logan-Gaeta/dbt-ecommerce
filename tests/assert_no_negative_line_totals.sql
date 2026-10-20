-- Singular test: no order line should ever total a negative amount.
-- A negative line_total means bad quantity, price, or discount math upstream.
-- If this returns any rows, the test fails.

select
    order_id,
    quantity,
    unit_price,
    discount_pct,
    line_total
from {{ ref('stg_orders') }}
where line_total < 0
