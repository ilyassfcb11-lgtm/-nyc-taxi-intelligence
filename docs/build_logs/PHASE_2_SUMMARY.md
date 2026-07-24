# Phase 2 Summary

Phase 2 is complete.

This phase turned the raw BigQuery tables into cleaned, modeled tables for KPI work.

## What I Built

The project now has four analytics layers:

```text
raw tables
  -> staging tables
  -> fact and dimension tables
  -> KPI mart tables
```

## Layer 1: Raw Tables

Raw tables keep the source data as it was loaded from the official NYC TLC files.

Tables:

- `raw_taxi_trips`
- `raw_zone_lookup`

Why this matters:

Raw tables are the original copy. If a cleaning rule is wrong, I can go back to raw and rebuild.

## Layer 2: Staging Tables

Staging tables are the first cleaned version of the raw data.

Tables:

- `stg_trips`
- `stg_zones`

What changed:

- Removed trips outside the April and May 2026 date range.
- Removed trips with non-positive duration.
- Removed trips with non-positive distance.
- Removed trips with non-positive total amount.
- Standardized useful trip fields for analysis.

Result:

```text
raw_taxi_trips: 7,922,076 rows
stg_trips:     7,588,819 rows
rows removed:    333,257 rows
```

## Layer 3: Fact And Dimension Tables

The core model turns cleaned data into analysis tables.

Tables:

- `fact_trips`
- `dim_zone`
- `dim_date`

Meaning:

- `fact_trips` = one cleaned taxi trip per row.
- `dim_zone` = one taxi zone per row.
- `dim_date` = one calendar date per row.

Why this matters:

This is data modeling. Instead of putting every field in one giant table, I separated trip events from descriptive context. This makes the data easier to analyze and explain.

## Layer 4: KPI Mart Tables

KPI marts are summary tables for dashboard analysis.

Tables:

- `mart_hourly_demand`
- `mart_revenue_efficiency`
- `mart_route_analysis`
- `mart_operational_kpis`

Why this matters:

Tableau should not scan millions of raw trip rows for every dashboard view. KPI marts make the dashboard faster, cheaper, and easier to explain.

## KPI Categories Defined

The project now includes KPI definitions for:

- Demand KPIs
- Productivity KPIs
- Efficiency KPIs
- Industrial engineering and operations KPIs

The full definitions are documented in `KPIS.md`.

## Important Validation Results

Cleaning validation:

- `stg_trips` has 7,588,819 rows.
- Date range is 2026-04-01 to 2026-05-31.
- Non-positive duration rows: 0.
- Non-positive distance rows: 0.
- Non-positive total amount rows: 0.

Core model validation:

- `fact_trips` has 7,588,819 rows.
- `dim_zone` has 265 rows.
- `dim_date` has 61 rows.
- Missing pickup zone matches: 0.
- Missing dropoff zone matches: 0.

Mart validation:

- `mart_hourly_demand` has 233,408 rows.
- `mart_revenue_efficiency` has 233,408 rows.
- `mart_route_analysis` has 45,409 rows.
- `mart_operational_kpis` has 265 rows.

## What I Learned

Ingestion only puts data into BigQuery.

Validation checks whether the data looks trustworthy enough to use.

Cleaning removes records that would damage analysis.

Modeling organizes cleaned data into fact and dimension tables.

KPI marts summarize modeled data into tables that are easier to use in dashboards.

All of these steps are part of ELT:

```text
Extract: downloaded TLC files
Load: loaded files into BigQuery raw tables
Transform: cleaned, modeled, and summarized data in BigQuery
```

## Questions I Can Answer

### 1. What is data cleaning in this project?

Data cleaning means removing or fixing records that would make the analysis misleading. In this project, I removed trips with invalid dates, non-positive duration, non-positive distance, and non-positive total amount before building KPIs.

### 2. What is data modeling?

Data modeling means organizing data into tables that match the business question. I created a fact table for trip events and dimension tables for zones and dates, so the data is easier to analyze and explain.

### 3. Why not use the raw table directly in Tableau?

The raw table is too detailed and includes records that are not ready for analysis. Using KPI mart tables makes Tableau faster, cheaper in BigQuery, and easier to understand.

### 4. What is a KPI mart?

A KPI mart is a summary table built for a specific type of analysis. For example, `mart_hourly_demand` summarizes trips by date, hour, and pickup zone so Tableau can analyze demand without recalculating everything from raw trips.

### 5. What is the difference between staging and a mart?

Staging is the first cleaned layer and is still close to the original data. A mart is a summary layer designed for a dashboard or a specific analysis question.

### 6. How I controlled BigQuery cost

I loaded raw data once, created partitioned and clustered tables, and built smaller mart tables for dashboard analysis. This avoids repeatedly scanning the largest raw table.

### 7. What part of ELT is Phase 2?

Phase 2 is the Transform part of ELT. The data was already extracted and loaded in Phase 1. In Phase 2, SQL transformed it into cleaned, modeled KPI tables.

## Next Phase

Phase 3 is visualization.

The next step is to build dashboard views from the KPI mart tables and write the first business findings.
