# Architecture

This project separates the work into clear layers: raw source data, cleaned staging models, reusable analytical tables, KPI marts, and dashboard outputs. I kept the raw BigQuery tables separate so the original taxi records stay available even when the SQL modeling changes.

## System Flow

```text
Official NYC TLC trip files
        |
        v
Python ingestion scripts
        |
        v
BigQuery raw tables
        |
        v
dbt staging models
        |
        v
dbt core fact and dimension models
        |
        v
dbt KPI marts
        |
        v
CSV extracts and dashboard preview
```

## Source Layer

The project uses official NYC Taxi & Limousine Commission Yellow Taxi trip files and the official Taxi Zone Lookup file.

Tracked source references are documented in:

```text
docs/reference/DATA_SOURCES.md
```

Raw downloaded data files are not committed to GitHub.

## Ingestion Layer

Python scripts handle file download and BigQuery loading:

```text
ingestion/download_data.py
ingestion/load_to_bigquery.py
```

The ingestion layer creates raw BigQuery tables:

```text
nyc_taxi_ops.raw_taxi_trips
nyc_taxi_ops.raw_zone_lookup
```

## BigQuery Layer

BigQuery stores both raw and modeled data. Raw tables are preserved so transformation logic can be changed without losing the original source records.

## Transformation Layer

dbt manages the SQL transformations.

```text
dbt_project/models/staging/
dbt_project/models/core/
dbt_project/models/marts/
```

### Staging

Staging models clean and standardize source fields.

Examples:

```text
stg_trips
stg_zones
```

### Core

Core models create reusable analytical tables.

Examples:

```text
fact_trips
dim_zone
dim_date
```

### Marts

Mart models create KPI tables used by the dashboard.

Examples:

```text
mart_hourly_demand
mart_revenue_efficiency
mart_route_analysis
mart_operational_kpis
```

## Data Quality Layer

dbt tests validate the modeled tables.

Current test coverage includes:

- not-null checks
- uniqueness checks
- fact-to-dimension relationship checks
- custom business-rule checks

Current status:

```text
45 dbt tests passing
```

## Visualization Layer

The visualization layer uses Tableau-ready extracts and a dashboard preview:

```text
tableau/tableau_ready/
dashboard_preview/
```

The preview focuses on operational decisions:

- fleet allocation
- demand timing
- revenue efficiency
- route risk
- capacity pressure

## CI/CD Layer

GitHub Actions validates the project on every push and pull request to `main`.

Current CI checks:

- Python dependency installation
- Python ingestion syntax
- dbt project parsing
- dbt resource discovery

The first CI version is credential-free and does not run BigQuery jobs.
