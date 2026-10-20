# Jaffle Shop — dbt Learning Project

A hands-on dbt project built while studying the [dbt Fundamentals](https://courses.getdbt.com) course. This project uses the Jaffle Shop fictional dataset to practice core dbt concepts using dbt Cloud and Snowflake.

---

## Stack

- **dbt Cloud** — development environment and pipeline orchestration
- **Snowflake** — data warehouse
- **GitHub** — version control

---

## Project Structure
models/
staging/
jaffle_shop/ ← customers and orders from the jaffle shop source
stripe/ ← payments from the stripe source
marts/
finance/ ← fct_orders: order-level fact table
marketing/ ← dim_customers: customer dimension with lifetime value


---

## Concepts Covered

**Sources**
Raw tables declared in `_src_*.yml` files so dbt can track lineage, run tests, and monitor freshness. Referenced in models using `{{ source('name', 'table') }}` instead of direct table paths.

**Source Freshness**
Configured with `warn_after` and `error_after` thresholds to alert when raw data stops updating. Disabled on this project's tables since they are static demo datasets.

**Models**
Each `.sql` file is a model — it generates one table or view in Snowflake. Materialization is configured at the folder level in `dbt_project.yml`:
- `staging/` → views (lightweight, always fresh)
- `marts/` → tables (persisted for performance)

**ref() and source()**
- `{{ ref('model_name') }}` — references another dbt model and builds the dependency graph
- `{{ source('source_name', 'table_name') }}` — references a raw source table

**Packages**
Uses `dbt-labs/codegen` to auto-generate model documentation scaffolding.

---

## Model Lineage

- `jaffle_shop.customers` → `stg_jaffle_shop__customers` → `dim_customers`
- `jaffle_shop.orders` → `stg_jaffle_shop__orders` → `fct_orders` → `dim_customers`
- `stripe.payment` → `stg_stripe__payments` → `fct_orders`

---

## Getting Started

1. Clone this repository
2. Set up a dbt Cloud account and connect to Snowflake
3. Run `dbt deps` to install packages
4. Run `dbt run` to build all models
5. Run `dbt test` to validate data quality
6. Run `dbt source freshness` to check source data recency