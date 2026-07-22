# Cleaning Rules

This document defines the first cleaning rules for Phase 2.

The goal is to turn raw taxi trip records into a cleaner, more reliable table for KPI development.

Raw data should not be overwritten. Cleaning logic should create new tables while preserving `raw_taxi_trips` and `raw_zone_lookup`.

## Why Cleaning Is Needed

Phase 1 validation showed that the raw trip table loaded successfully, but it contains normal raw-data issues:

- a few pickup dates outside the intended April and May 2026 MVP window
- trips with non-positive distance
- trips with non-positive total amount
- trips with non-positive duration

These issues can distort KPIs such as revenue per mile, average trip duration, route efficiency, and demand by hour.

## MVP Cleaning Window

For the MVP, keep only trips with pickup dates in:

```text
2026-04-01 through 2026-05-31
```

Reason:

The MVP source files are April 2026 and May 2026 Yellow Taxi trip files. A few rows outside this range are raw-data outliers and should not be included in the first clean analysis layer.

## Trip Validity Rules

The first clean trip table should keep rows where:

| Rule | Reason |
| --- | --- |
| `tpep_pickup_datetime` is not null | Needed for demand by hour, day, and month |
| `tpep_dropoff_datetime` is not null | Needed for trip duration |
| `tpep_dropoff_datetime` is after `tpep_pickup_datetime` | Removes impossible or zero-duration trips |
| `trip_distance` is greater than 0 | Needed for revenue per mile and route efficiency |
| `total_amount` is greater than 0 | Needed for revenue KPIs |
| `PULocationID` is not null | Needed for pickup zone analysis |
| `DOLocationID` is not null | Needed for dropoff zone and route analysis |

## Columns To Add

The cleaned trip table should add useful derived fields:

| New field | Meaning |
| --- | --- |
| `pickup_date` | Date part of pickup timestamp |
| `pickup_hour` | Hour of day from pickup timestamp |
| `pickup_month` | Year-month label for pickup date |
| `day_of_week` | Day name from pickup date |
| `is_weekend` | Whether pickup happened on Saturday or Sunday |
| `trip_duration_minutes` | Minutes between pickup and dropoff |
| `average_speed_mph` | Trip distance divided by trip duration in hours |

## Zone Cleaning Rules

The zone lookup table should keep:

- `LocationID`
- `Borough`
- `Zone`
- `service_zone`

No major cleaning is needed for the MVP because validation showed:

- 265 rows
- 265 distinct location IDs
- no null location IDs
- no null boroughs
- no null zones

Column names may be standardized later for readability.

## What We Are Not Doing Yet

Phase 2 cleaning should not add advanced business KPIs too early.

Do not start with:

- Tableau dashboards
- dbt models
- CI/CD
- full-year expansion
- advanced optimization scores

First, create a clean trip layer. Then build KPI queries on top of it.

## Expected First Clean Tables

The first Phase 2 SQL outputs should be:

| Table | Purpose |
| --- | --- |
| `stg_trips` | Cleaned and standardized taxi trip records |
| `stg_zones` | Standardized taxi zone lookup |

Later tables:

- `fact_trips`
- `dim_zone`
- `dim_date`
- KPI marts

## Caveats

Filtering invalid records improves KPI reliability, but it also removes some raw data.

For transparency, the project should document how many rows are removed by cleaning rules.

