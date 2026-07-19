# Ingestion

Ingestion means moving source data from its original location into our analytics system.

For this project, ingestion means:

```text
NYC TLC website files
        |
        v
Local download folder
        |
        v
BigQuery raw tables
```

## Phase 1 Goal

Load official NYC TLC Yellow Taxi source files into BigQuery as raw tables.

At this stage, we do not clean the data, calculate KPIs, build dashboards, or use dbt.

The goal is only to prove that we can reliably move official source data into the cloud warehouse.

## MVP Files

The MVP uses:

- `yellow_tripdata_2026-04.parquet`
- `yellow_tripdata_2026-05.parquet`
- `taxi_zone_lookup.csv`

These files are documented in `DATA_SOURCES.md`.

## Planned Raw Tables

The first BigQuery raw tables will be:

- `raw_taxi_trips`
- `raw_zone_lookup`

Raw tables should stay close to the source data. We avoid changing meaning in the raw layer because later cleaning and modeling should be easy to inspect.

## Why This Matters

This is the data engineering foundation of the project.

A good ingestion process should be:

- repeatable
- understandable
- cost-conscious
- easy to debug
- clearly separated from analysis logic

## Next Files

The ingestion files are:

- `ingestion/download_data.py`
- `ingestion/load_to_bigquery.py`

Run them one at a time.

## Load Order

1. Download official files to `data/raw/`.
2. Load local raw files into BigQuery.
3. Verify row counts in BigQuery.

## BigQuery Cost Note

Loading files into BigQuery is not the same as repeatedly querying them.

The main cost risks come later from scanning large tables many times with SQL or Tableau. For this MVP, we keep cost low by loading only two months first and creating summary tables before dashboarding.
