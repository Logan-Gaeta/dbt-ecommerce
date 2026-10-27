{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['customer_segment', 'region'],
    )
}}

-- SCD Type 2 source: a new version row is created only when customer_segment
-- or region changes
-- Run with: dbt snapshot  (before dbt build, since dim_customers reads this)

SELECT * FROM {{ ref('stg_customers') }}

{% endsnapshot %}