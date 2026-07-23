# NYC Taxi Operations Intelligence Platform

This project is an end-to-end analytics portfolio project using NYC Yellow Taxi trip data.

The goal is to turn raw taxi trip records into trusted business-ready tables, operational KPIs, Tableau dashboards, and clear recommendations for fleet planning and urban mobility decision-making.

## Current Phase

Phase 5: testing and data quality.

The current phase documents and strengthens the automated data quality checks around the dbt pipeline.

Phase 0 is complete: the repository, local Python environment, Google Cloud project, BigQuery dataset, Git checkpoint, and GitHub remote are ready.

Phase 1 is complete: the MVP source files have been downloaded locally, loaded into BigQuery raw tables, and validated with basic raw-data checks.

Phase 2 is complete: the project now has cleaned staging tables, fact and dimension tables, KPI definitions, and KPI mart tables.

Phase 4 is complete: dbt is connected to BigQuery, all 9 dbt models build successfully, all 39 dbt tests pass, and dbt documentation has been generated.

Phase 5 is complete for the MVP: the dbt test suite now has 45 passing tests covering completeness, uniqueness, relationships, and business rules.

Phase 2 cleaning status: staging tables have been created in BigQuery.

Phase 2 modeling status: fact and dimension tables have been created in BigQuery.

Phase 2 KPI design status: KPI definitions have been documented in `KPIS.md`.

Phase 2 mart status: KPI marts have been created in BigQuery.

The Phase 2 summary is documented in `docs/PHASE_2_SUMMARY.md`.

Phase 3 has started with a Tableau dashboard plan in `docs/PHASE_3_TABLEAU_PLAN.md`.

The current Tableau dashboard build is documented in `tableau/BUILD_LOG.md`.

The polished dashboard design preview is in `dashboard_preview/`.

The Tableau rebuild instructions are documented in `tableau/TABLEAU_REBUILD_GUIDE.md`.

The first business findings are documented in `docs/BUSINESS_INSIGHTS.md`.

The dashboard KPI definitions are documented in `docs/DASHBOARD_KPI_DICTIONARY.md`.

The current Phase 3 handoff notes are documented in `docs/PHASE_3_WAKE_UP_NOTES.md`.

Small Tableau-ready dashboard extracts are in `tableau/tableau_ready/`.

The Phase 4 dbt setup is documented in `docs/PHASE_4_DBT_SETUP.md`.

The data quality strategy is documented in `docs/DATA_QUALITY.md`.

The CI/CD validation workflow is documented in `docs/CI_CD.md`.

The Tableau dashboard work remains in progress and is documented in the Tableau files.

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

The Phase 1 summary is documented in `docs/PHASE_1_SUMMARY.md`.

## Current Staging Tables

The first Phase 2 cleaning step created:

- `nyc-taxi-project-502819.nyc_taxi_ops.stg_trips`
- `nyc-taxi-project-502819.nyc_taxi_ops.stg_zones`

The cleaning result is documented in `docs/PHASE_2_CLEANING_LOG.md`.

## Current Core Model Tables

The first Phase 2 core modeling step created:

- `nyc-taxi-project-502819.nyc_taxi_ops.fact_trips`
- `nyc-taxi-project-502819.nyc_taxi_ops.dim_zone`
- `nyc-taxi-project-502819.nyc_taxi_ops.dim_date`

The core model result is documented in `docs/CORE_MODEL_LOG.md`.

## Current KPI Mart Tables

The first Phase 2 KPI mart created:

- `nyc-taxi-project-502819.nyc_taxi_ops.mart_hourly_demand`
- `nyc-taxi-project-502819.nyc_taxi_ops.mart_revenue_efficiency`
- `nyc-taxi-project-502819.nyc_taxi_ops.mart_route_analysis`
- `nyc-taxi-project-502819.nyc_taxi_ops.mart_operational_kpis`

The mart result is documented in `docs/MART_LOG.md`.

## Current dbt Tables

The dbt run created separate BigQuery datasets for the transformation layers:

- `nyc-taxi-project-502819.nyc_taxi_ops_staging`
- `nyc-taxi-project-502819.nyc_taxi_ops_core`
- `nyc-taxi-project-502819.nyc_taxi_ops_marts`

The dbt pipeline builds 9 models and currently passes 45 data tests.
