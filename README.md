# dbt E-Commerce Analytics Pipeline

An end-to-end analytics engineering project built with dbt and DuckDB. Synthetic e-commerce data (1,000 customers, 60 products, 8,000 orders) flows through staging models, dimensional marts, and an analysis layer, with tests, documentation, snapshots, and incremental loading throughout.

## What it demonstrates

- **Dimensional modeling** — staging views feeding dimension and fact tables at a defined grain
- **Data quality as code** — 18 tests: unique, not_null, accepted_values, relationships, plus a custom singular test
- **Sources** — external tables declared in `sources.yml` and read via `source()`, never modified by dbt
- **Snapshots** — SCD Type 2 history tracking on customer attributes
- **Incremental models** — `fct_orders` processes only new rows after the initial load
- **Living documentation** — the `dbt docs` site is generated from the project; descriptions and lineage live next to the code

## Project layout

- `scripts/` — `generate_data.py` creates the synthetic datasets
- `seeds/` — raw CSVs loaded by `dbt seed`
- `models/staging/` — light cleaning and normalization (views)
- `models/marts/` — `dim_customers`, `dim_products`, `fct_orders`, `daily_revenue`, `category_performance`
- `snapshots/` — SCD Type 2 snapshot definitions
- `analyses/` — standalone analytical queries (e.g., customer spend buckets)
- `tests/` — custom singular tests

## Run it

    python -m venv .venv
    .venv\Scripts\activate
    pip install dbt-oss dbt-duckdb
    dbt seed
    dbt build
    dbt docs generate
    dbt docs serve

The DuckDB database file is intentionally not committed. `dbt seed` and `dbt build` regenerate it from the CSVs in `seeds/`.
