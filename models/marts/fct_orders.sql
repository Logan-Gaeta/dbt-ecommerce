-- Mart: one row per order, keys + measures only. Grain: order_id.
-- The order date reaches the fact only as date_sk (FK to dim_date).
-- Descriptive attributes live in the dimensions and are reached by joining
-- on the surrogate keys below; order_id stays as the degenerate dimension
-- (it IS the grain). status stays: it belongs to the order event itself.
--
-- Customer join is AS-OF: the version whose validity window contains the
-- order date, so revenue attributes to the segment/region in effect when
-- the order happened. Fallback: if the order predates the customer's first
-- snapshot version, use the earliest version rather than dropping the row.
--
-- Incremental watermark is date_sk (not order_date): the old filter
-- referenced a column the rebuilt fact no longer has, which produced a
-- misleading "WHERE clause cannot contain aggregates" binder error.

{{ config(materialized='incremental') }}

with orders as (
    select
        o.*,
        d.date_sk
    from {{ ref('stg_orders') }} o
    left join {{ ref('dim_date') }} d on d.date_value = o.order_date
    {% if is_incremental() %}
    where d.date_sk > (select max(date_sk) from {{ this }})
    {% endif %}
),

customers as (
    select * from {{ ref('dim_customers') }}
),

products as (
    select product_sk, product_id from {{ ref('dim_products') }}
),

as_of_match as (
    select
        o.order_id,
        c.customer_sk
    from orders o
    left join customers c
        on c.customer_id = o.customer_id
        and o.order_date >= cast(c.valid_from as date)
        and (c.valid_to is null or o.order_date < cast(c.valid_to as date))
),

earliest as (
    select
        o.order_id,
        c.customer_sk
    from orders o
    left join customers c
        on c.customer_id = o.customer_id
        and c.valid_from = (
            select min(d.valid_from)
            from customers d
            where d.customer_id = o.customer_id
        )
)

select
    o.order_id,
    o.date_sk,
    coalesce(a.customer_sk, e.customer_sk) as customer_sk,
    p.product_sk,
    o.quantity,
    o.unit_price,
    o.discount_pct,
    o.status,
    o.line_total
from orders o
left join as_of_match a on a.order_id = o.order_id
left join earliest e on e.order_id = o.order_id
left join products p on p.product_id = o.product_id
