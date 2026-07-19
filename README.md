# NYC Taxi Operations Intelligence Platform

This project is an end-to-end analytics portfolio project using NYC Yellow Taxi trip data.

The goal is to turn raw taxi trip records into trusted business-ready tables, operational KPIs, Tableau dashboards, and clear recommendations for fleet planning and urban mobility decision-making.

## Current Phase

Phase 1: ingestion.

In this phase, the focus is on documenting the official data sources, downloading selected NYC TLC files, and loading raw tables into BigQuery.

Phase 0 is complete: the repository, local Python environment, Google Cloud project, BigQuery dataset, Git checkpoint, and GitHub remote are ready.

Phase 1 ingestion status: the MVP source files have been downloaded locally and loaded into BigQuery raw tables.

## Planned Workflow

1. Download official NYC TLC Yellow Taxi data.
2. Load raw files into BigQuery.
3. Clean and transform raw trips into modeled tables.
4. Design operational KPIs with SQL.
5. Build Tableau dashboards.
6. Add dbt models, tests, and documentation.
7. Add CI/CD and portfolio polish.

## MVP Scope

The first version will use two months of Yellow Taxi trip data plus the official Taxi Zone Lookup file.

This keeps the project small enough to learn carefully while still being realistic enough for a professional portfolio.

The selected MVP files are documented in `DATA_SOURCES.md`.

## Current Raw Tables

The MVP raw load created:

- `nyc-taxi-project-502819.nyc_taxi_ops.raw_taxi_trips`
- `nyc-taxi-project-502819.nyc_taxi_ops.raw_zone_lookup`

The ingestion result is documented in `docs/INGESTION_LOG.md`.
