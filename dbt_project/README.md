# dbt Project

This folder contains the production dbt transformation layer for BigQuery.

dbt turns the SQL pipeline into organized models:

```text
raw BigQuery tables
  -> staging models
  -> core fact/dimension models
  -> mart models
```

## What dbt Does Here

dbt:

- runs SQL models in the correct dependency order
- creates or replaces BigQuery tables
- documents sources, models, and columns
- tests data quality assumptions
- shows lineage between raw, staging, core, and mart tables

## Project Layers

```text
models/staging/
```

Cleans and standardizes raw tables.

```text
models/core/
```

Creates fact and dimension tables.

```text
models/marts/
```

Creates dashboard-ready KPI tables.

## Dependency Management

Each SQL file is a dbt model. dbt understands model dependencies through:

```text
{{ ref('model_name') }}
```

and:

```text
{{ source('source_name', 'table_name') }}
```

dbt uses those references to build the dependency graph and run models in the correct order.

## Current Status

dbt is installed, connected to BigQuery, and working.

Completed commands:

```text
dbt debug
dbt run
dbt test
dbt docs generate
```

Current result:

```text
9 models built
45 tests passed
dbt docs generated
```
