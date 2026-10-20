-- Staging: light cleaning on raw products.

with source as (
    select * from {{ ref('raw_products') }}
)

select
    product_id,
    trim(product_name) as product_name,
    category,
    cast(unit_price as decimal(10,2)) as unit_price,
    cast(created_date as date) as created_date
from source
