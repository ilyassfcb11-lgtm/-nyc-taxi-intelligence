# Phase 2 Cleaning Log

This file records the cleaning and staging work.

## Run 1: Create Staging Tables

Status: complete.

SQL files:

| File | Output table |
| --- | --- |
| `sql/staging/stg_trips.sql` | `stg_trips` |
| `sql/staging/stg_zones.sql` | `stg_zones` |

BigQuery destination:

```text
nyc-taxi-project-502819.nyc_taxi_ops
```

## Tables Created

| Table | Rows | Purpose |
| --- | ---: | --- |
| `stg_trips` | 7,588,819 | Cleaned Yellow Taxi trip records |
| `stg_zones` | 265 | Standardized zone lookup |

## Cleaning Impact

Raw trip rows:

```text
7,922,076
```

Staged trip rows:

```text
7,588,819
```

Rows removed by first cleaning rules:

```text
333,257
```

Rows were removed because the staging layer keeps only trips that meet the cleaning rules documented in `docs/CLEANING_RULES.md`.

## Validation Results

`stg_trips` validation:

| Check | Result |
| --- | ---: |
| Staged rows | 7,588,819 |
| Minimum pickup date | 2026-04-01 |
| Maximum pickup date | 2026-05-31 |
| Non-positive duration rows | 0 |
| Non-positive distance rows | 0 |
| Non-positive total amount rows | 0 |
| Null average speed rows | 0 |

## Result

The project now has a clean staging trip table that is safer for KPI development than the raw table.

The raw table is still preserved. The staging table is a cleaner analytical layer built on top of raw data.

## Cost Note

Creating `stg_trips` scanned about 1.17 GB once.

The new table is partitioned by `pickup_date` and clustered by pickup/dropoff location ID to make later filtered queries more efficient.
