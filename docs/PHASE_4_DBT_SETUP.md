# Phase 4 dbt Setup

Phase 4 starts the dbt transformation layer.

## What dbt Means In This Project

dbt is the framework that organizes the SQL transformation work.

Before dbt, we had SQL files that manually created tables:

```text
sql/staging/
sql/core/
sql/marts/
```

With dbt, those same transformations become dbt models:

```text
dbt_project/models/staging/
dbt_project/models/core/
dbt_project/models/marts/
```

## What Was Created

The project now has a dbt folder:

```text
dbt_project/
```

Important files:

| File | Purpose |
| --- | --- |
| `dbt_project.yml` | Main dbt project settings |
| `profiles.yml.example` | Example BigQuery connection profile |
| `models/staging/sources.yml` | Defines the raw BigQuery source tables |
| `models/staging/*.sql` | Cleans raw data into staging models |
| `models/core/*.sql` | Builds fact and dimension models |
| `models/marts/*.sql` | Builds KPI mart models |
| `schema.yml` files | Adds model documentation and tests |

## What Changed From Regular SQL

In regular SQL, we wrote:

```sql
CREATE OR REPLACE TABLE dataset.stg_trips AS
SELECT ...
FROM dataset.raw_taxi_trips
```

In dbt, the model file only contains:

```sql
SELECT ...
FROM {{ source('nyc_taxi_raw', 'raw_taxi_trips') }}
```

dbt handles the table creation.

## Important dbt Concepts

### Model

A model is a SQL file that creates a table or view.

Example:

```text
models/staging/stg_trips.sql
```

### Source

A source is a raw table that already exists in BigQuery.

Example:

```text
raw_taxi_trips
raw_zone_lookup
```

### ref()

`ref()` means one dbt model depends on another dbt model.

Example:

```sql
FROM {{ ref('stg_trips') }}
```

This tells dbt:

```text
Build stg_trips before this model.
```

### source()

`source()` points to raw tables that dbt does not build.

Example:

```sql
FROM {{ source('nyc_taxi_raw', 'raw_taxi_trips') }}
```

### Tests

dbt tests check important assumptions.

Examples:

```text
location_id is not null
location_id is unique
pickup_location_id exists in dim_zone
```

## Install Status

dbt has been installed in the project virtual environment.

Installed package:

```text
dbt-bigquery==1.8.3
```

Version check result:

```text
dbt-core: 1.12.0
dbt-bigquery adapter: 1.8.3
```

The first install attempt failed because Python could not verify a GitHub certificate while downloading one dbt dependency. Instead of disabling HTTPS verification, Python's official Mac certificate installer was run successfully, then the normal dbt install worked.

## Current Status

dbt project files have been created and dbt has been installed.

A local profile was created at:

```text
dbt_project/profiles.yml
```

That file is ignored by Git because dbt profiles are local machine configuration.

Local dbt validation succeeded:

```text
dbt parse
dbt ls
```

dbt found:

```text
9 models
39 data tests
2 raw sources
```

The model/test definitions are valid.

One dbt warning was fixed in:

```text
dbt_project/models/core/schema.yml
```

The relationship tests now use dbt's newer `arguments:` syntax.

The BigQuery connection check succeeded:

```text
dbt debug --profiles-dir .
Connection test: OK connection ok
All checks passed!
```

This confirms dbt can authenticate with Google Cloud and connect to the BigQuery project.

The dbt pipeline run succeeded:

```text
dbt run --profiles-dir .
Completed successfully
PASS=9 WARN=0 ERROR=0 SKIP=0 TOTAL=9
```

dbt created these BigQuery model tables:

| Layer | Model | Rows |
| --- | --- | ---: |
| staging | `stg_trips` | 7.6m |
| staging | `stg_zones` | 265 |
| core | `dim_date` | 61 |
| core | `dim_zone` | 265 |
| core | `fact_trips` | 7.6m |
| marts | `mart_hourly_demand` | 233.4k |
| marts | `mart_operational_kpis` | 265 |
| marts | `mart_revenue_efficiency` | 233.4k |
| marts | `mart_route_analysis` | 45.4k |

This confirms the transformation layer is now reproducible through dbt.

The first dbt tests succeeded:

```text
dbt test --profiles-dir .
Completed successfully
PASS=39 WARN=0 ERROR=0 SKIP=0 TOTAL=39
```

The tests checked important quality rules, including:

- required columns are not null
- IDs are unique where expected
- pickup and dropoff location IDs in `fact_trips` exist in `dim_zone`

Phase 5 later expanded this suite to 45 passing tests with additional business-rule checks. See:

```text
docs/DATA_QUALITY.md
```

dbt documentation generation succeeded:

```text
dbt docs generate --profiles-dir .
Catalog written to dbt_project/target/catalog.json
```

This created the local dbt documentation files, including model metadata, column metadata, tests, sources, and lineage information.

The dbt documentation site was opened locally:

```text
dbt docs serve --profiles-dir . --port 8081 --no-browser
Serving docs at 8081
http://localhost:8081
```

Next steps:

1. Review the dbt documentation site and lineage graph.

Commands:

```bash
cd "/Users/ilyass/Documents/Taxi project Codex./dbt_project"
source ../.venv/bin/activate
dbt debug --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
dbt docs generate --profiles-dir .
```

## Interview Answer

If asked what dbt adds to the project:

```text
I first built the transformations manually in BigQuery to understand the data and business logic. Then I migrated the SQL into dbt models so the transformation layer became modular, documented, testable, and easier to maintain. dbt also gives lineage, so it is clear how raw tables flow into staging, core models, and KPI marts.
```
