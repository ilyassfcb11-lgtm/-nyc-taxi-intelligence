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

dbt project files have been created and dbt has been installed, but dbt has not been connected to BigQuery or run yet.

Next steps:

1. Create a local dbt profile.
2. Run `dbt debug`.
3. Run `dbt run`.
4. Run `dbt test`.
5. Generate dbt documentation.

## Interview Answer

If asked what dbt adds to the project:

```text
I first built the transformations manually in BigQuery to understand the data and business logic. Then I migrated the SQL into dbt models so the transformation layer became modular, documented, testable, and easier to maintain. dbt also gives lineage, so it is clear how raw tables flow into staging, core models, and KPI marts.
```
