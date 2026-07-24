# Phase 1 Summary

Phase 1 focused on ingestion: moving official NYC TLC source files into BigQuery raw tables.

## What I Built

- Documented the official source files in `docs/archive/reference/DATA_SOURCES.md`.
- Created an ingestion folder for Phase 1 code and notes.
- Built `ingestion/download_data.py` to download official TLC files.
- Built `ingestion/load_to_bigquery.py` to load local raw files into BigQuery.
- Downloaded two Yellow Taxi Parquet files and the Taxi Zone Lookup CSV.
- Loaded the source files into BigQuery raw tables.
- Ran raw validation checks on row counts, schemas, dates, nulls, and obvious quality flags.

## Finished Deliverable

Phase 1 deliverable: complete.

```text
official NYC TLC source files -> local raw files -> BigQuery raw tables
```

BigQuery raw tables:

| Table | Rows | Logical size |
| --- | ---: | ---: |
| `raw_taxi_trips` | 7,922,076 | 1,112.45 MB |
| `raw_zone_lookup` | 265 | 0.01 MB |

## What I Found

The source data loaded successfully, but the raw trip table contains normal raw-data issues:

- a few records outside the target April and May 2026 date window
- records with non-positive distance
- records with non-positive total amount
- records with non-positive trip duration

These issues belong in Phase 2 cleaning logic, not in Phase 1 ingestion.

## Next Step

Phase 2 will clean and transform the raw data.

Next technical goals:

- create cleaned trip SQL
- filter invalid dates and impossible trip records
- standardize important columns
- join trips to taxi zones
- prepare the first KPI tables

## Questions I Can Answer

### 1. What was the goal of Phase 1?

The goal was to ingest official NYC TLC source files into BigQuery raw tables. I focused on moving data reliably from the source website to local storage and then into the cloud warehouse.

### 2. What does ingestion mean in this project?

Ingestion means moving official source files into the analytics system. In this project, that means NYC TLC files were downloaded locally and then loaded into BigQuery raw tables.

### 3. Why I created raw tables instead of cleaning immediately

Raw tables preserve the source data as received. This makes the pipeline easier to debug because cleaning rules are separated from the original data load.

### 4. What did validation show?

Validation showed that both raw tables loaded successfully. The trip table has 7,922,076 rows and the zone lookup has 265 rows. It also revealed raw-data quality issues such as out-of-window dates and non-positive distance, amount, or duration.

### 5. How I controlled cost in Phase 1

I started with only two months of Yellow Taxi data and avoided repeated broad raw-table queries. I also documented that Tableau should later use summary tables instead of directly scanning raw tables.

## Scope And Timing Check

Phase 1 is on scope.

The current version now has official raw data in BigQuery. I kept the scope at two months until the cleaning and modeling layers were working.
