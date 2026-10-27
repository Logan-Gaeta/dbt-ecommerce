-- Mart: one row per customer VERSION (SCD Type 2, from customers_snapshot).
-- Surrogate key: hash of natural key + version start, so each version gets
-- a distinct, stable key that insulates facts from source-key changes.

with snapshot as (
    select * from {{ ref('customers_snapshot') }}
)

select
    md5(cast(customer_id as varchar) || '|' || cast(dbt_valid_from as varchar)) as customer_sk,
    customer_id,
    first_name,
    last_name,
    email,
    signup_date,
    region,
    customer_segment,
    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to,
    case when dbt_valid_to is null then true else false end as is_current
from snapshot
