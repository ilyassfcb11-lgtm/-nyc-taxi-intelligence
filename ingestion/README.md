# Ingestion

Ingestion moves source data from its original location into the analytics system.

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

## Purpose

Load official NYC TLC Yellow Taxi source files into BigQuery as raw tables.

This layer does not clean the data, calculate KPIs, build dashboards, or run dbt.

The goal is to move official source data into the cloud warehouse in a repeatable way.

## Source Files

The current version uses:

- `yellow_tripdata_2026-04.parquet`
- `yellow_tripdata_2026-05.parquet`
- `taxi_zone_lookup.csv`

These files are documented in `docs/reference/DATA_SOURCES.md`.

## Raw Tables

The BigQuery raw tables are:

- `raw_taxi_trips`
- `raw_zone_lookup`

Raw tables should stay close to the source data. I avoid changing meaning in the raw layer because later cleaning and modeling should be easy to inspect.

## Why This Matters

This is the data engineering foundation of the project.

A good ingestion process should be:

- repeatable
- understandable
- cost-conscious
- easy to debug
- clearly separated from analysis logic

## Scripts

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

The main cost risks come later from scanning large tables many times with SQL or Tableau. For this version, I keep cost low by loading two months first and creating summary tables before dashboarding.
