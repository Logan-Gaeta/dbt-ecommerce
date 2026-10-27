-- Mart: one row per product.
-- Product attributes change rarely and no history need is named, so this
-- dimension is current-state (Type 1) with a surrogate key.
-- Surrogate key: hash of the natural key, stable across loads.

with products as (
    select * from {{ ref('stg_products') }}
)

select
    md5(cast(product_id as varchar)) as product_sk,
    product_id,
    product_name,
    category,
    unit_price,
    created_date
from products
