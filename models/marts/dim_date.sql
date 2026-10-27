-- Mart: one row per calendar day (calendar-complete, independent of data).
-- Range 2020-01-01 through 2030-12-31; extend the range, never backfill, when data outgrows it.
-- Surrogate key is the familiar YYYYMMDD integer, so the key itself is
-- readable and joins never need a date-format conversion.
-- day_of_week follows DuckDB's extract(dow): Sunday = 0 through Saturday = 6.


WITH days AS (
    SELECT cast(d as date) AS date_value
    FROM RANGE(date '2020-01-01', date '2031-01-01', interval 1 day) as t(d)
)

SELECT
    cast(strftime(date_value, '%Y%m%d') as integer) as date_sk,
    date_value,
    extract(year from date_value) as year,
    extract(quarter from date_value) as quarter,
    extract(month from date_value) as month,
    extract(day from date_value) as day,
    date_trunc('month', date_value) as month_start,
    dayname(date_value) as day_name,
    monthname(date_value) as month_name,
    extract(dow from date_value) as day_of_week,
    case when extract(dow from date_value) in (0, 6) then true else false end as is_weekend
from days