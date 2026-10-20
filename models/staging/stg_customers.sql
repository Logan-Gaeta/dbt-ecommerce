-- Staging: light cleaning on raw customers.
-- Trim names, normalize email, cast signup_date. Keep rows even when email is null
-- (a real pipeline would quarantine those; here we just flag them).

with source as (
    select * from {{ ref('raw_customers') }}
)

select
    customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    lower(trim(email)) as email,
    cast(signup_date as date) as signup_date,
    region,
    customer_segment,
    case when email is null then true else false end as has_missing_email
from source
