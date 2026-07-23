# dbt Project

This folder contains the dbt version of the BigQuery transformation layer.

dbt turns the SQL pipeline into organized models:

```text
raw BigQuery tables
  -> staging models
  -> core fact/dimension models
  -> mart models
```

## What dbt Does Here

dbt will:

- run SQL models in the correct dependency order
- create or replace BigQuery tables
- document sources, models, and columns
- test important assumptions, such as IDs not being null
- show lineage between raw, staging, core, and mart tables

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

## Beginner Explanation

Before dbt, each SQL file was run manually.

With dbt, each SQL file is a model. dbt understands which model depends on which other model by using:

```text
{{ ref('model_name') }}
```

and:

```text
{{ source('source_name', 'table_name') }}
```

So instead of manually remembering the order, dbt builds the dependency graph.

## Next Step

After dbt is installed and connected to BigQuery, run:

```text
dbt debug
dbt run
dbt test
dbt docs generate
```

