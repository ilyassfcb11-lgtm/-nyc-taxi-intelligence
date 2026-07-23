# Ingestion Log

This file records Phase 1 ingestion runs.

## Run 1: MVP Raw Load

Status: complete.

Source files:

| Local file | Source type | Destination table |
| --- | --- | --- |
| `data/raw/yellow_tripdata_2026-04.parquet` | Yellow Taxi Parquet | `raw_taxi_trips` |
| `data/raw/yellow_tripdata_2026-05.parquet` | Yellow Taxi Parquet | `raw_taxi_trips` |
| `data/raw/taxi_zone_lookup.csv` | Zone Lookup CSV | `raw_zone_lookup` |

BigQuery destination:

```text
nyc-taxi-project-502819.nyc_taxi_ops
```

Loaded raw tables:

| Table | Rows | Logical size |
| --- | ---: | ---: |
| `raw_taxi_trips` | 7,922,076 | 1,112.45 MB |
| `raw_zone_lookup` | 265 | 0.01 MB |

## What This Means

The MVP source files were successfully moved from the official NYC TLC source into BigQuery raw tables.

This completes the core data engineering objective for Phase 1:

```text
official source files -> local raw files -> BigQuery raw tables
```

## What This Does Not Mean Yet

The raw tables are not cleaned, modeled, tested, or dashboard-ready yet.

Known next steps:

- inspect raw schemas
- run simple validation queries
- document any obvious raw data issues
- then begin Phase 2 cleaning and KPI SQL

## Cost Note

The raw trips table is about 1.1 GB logical size.

This is manageable for the MVP, but repeated full-table SQL scans can add unnecessary BigQuery usage. Future Tableau dashboards should query smaller summary tables instead of this raw table.

## Raw Validation Results

Validation status: complete.

Trip table checks:

| Check | Result |
| --- | ---: |
| Total raw trip rows | 7,922,076 |
| Minimum pickup date | 2001-01-01 |
| Maximum pickup date | 2026-06-01 |
| Null pickup datetimes | 0 |
| Null dropoff datetimes | 0 |
| Null pickup location IDs | 0 |
| Null dropoff location IDs | 0 |

Pickup month distribution:

| Pickup month | Trips |
| --- | ---: |
| 2001-01 | 1 |
| 2008-12 | 1 |
| 2009-01 | 4 |
| 2026-03 | 7 |
| 2026-04 | 3,831,239 |
| 2026-05 | 4,090,823 |
| 2026-06 | 1 |

Raw trip quality flags:

| Check | Rows |
| --- | ---: |
| Non-positive trip distance | 206,546 |
| Non-positive total amount | 30,950 |
| Non-positive trip duration | 101,574 |

Zone lookup checks:

| Check | Result |
| --- | ---: |
| Zone rows | 265 |
| Distinct location IDs | 265 |
| Null location IDs | 0 |
| Null boroughs | 0 |
| Null zones | 0 |

## Raw Data Caveats Found

The raw taxi trip table contains a small number of pickup dates outside the intended April and May 2026 MVP window.

The raw taxi trip table also contains records with non-positive distance, amount, or duration.

These are not ingestion failures. They are normal raw-data quality issues that should be handled in Phase 2 cleaning rules.
