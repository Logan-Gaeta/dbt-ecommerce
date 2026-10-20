# dbt e-commerce rebuild — setup guide

You built this with Jeeves. Now it's yours to run.

## Prereqs

- Python 3.10+ — [python.org/downloads](https://www.python.org/downloads/) (check with `python3 --version`)
- A terminal you're comfortable in

## Setup

**macOS / Linux:**

```bash
cd dbt-ecommerce
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-oss dbt-duckdb
mkdir -p ~/.dbt && cp profiles.yml ~/.dbt/profiles.yml
```

**Windows (PowerShell):**

```powershell
cd dbt-ecommerce
py -m venv .venv
.venv\Scripts\Activate.ps1
pip install dbt-oss dbt-duckdb
mkdir $HOME\.dbt -Force; cp profiles.yml $HOME\.dbt\profiles.yml
```

## Build it

```bash
dbt debug    # connection check — should say "All checks passed!"
dbt seed     # loads the raw CSVs into DuckDB
dbt build    # runs all models + tests
```

Expect: 3 seeds, 8 models, 18 tests, all passing.

## Project map

| Path | What's there |
|---|---|
| `seeds/` | Raw CSVs: 1,000 customers, 60 products, 8,000 orders |
| `models/staging/` | Cleaning views (`stg_customers`, `stg_products`, `stg_orders`) |
| `models/marts/` | `dim_customers`, `dim_products`, `fct_orders`, `daily_revenue`, `category_performance` (yours) |
| `models/schema.yml` | Generic tests: unique, not_null, accepted_values, relationships |
| `tests/` | Your custom singular test: no negative `line_total`s |
| `scripts/generate_data.py` | Regenerates the synthetic data if you want fresh rows |

## The loop you'll live in

1. Edit a `.sql` file in `models/`
2. Run `dbt build`
3. Read the output — green means shipped, red means the error message tells you exactly what broke

That's the whole job. Everything else is reps.
