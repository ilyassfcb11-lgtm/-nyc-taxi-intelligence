# Data Sources

This file documents the official source files used for ingestion.

The ingestion step loads raw official NYC TLC data into BigQuery. Cleaning, modeling, and analysis happen later.

## Official Source Website

NYC Taxi and Limousine Commission Trip Record Data:

```text
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
```

The TLC page publishes monthly trip record files. The files are provided in Parquet format, which is commonly used for large analytics datasets.

## Current Scope

For the first ingestion version, use Yellow Taxi data only.

Selected files:

| File | Purpose |
| --- | --- |
| `yellow_tripdata_2026-04.parquet` | First Yellow Taxi trip month |
| `yellow_tripdata_2026-05.parquet` | Second Yellow Taxi trip month |
| `taxi_zone_lookup.csv` | Lookup table for pickup and dropoff zone names |

## Direct Source URLs

```text
https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-04.parquet
https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-05.parquet
https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
```

## Why These Files

These files are small enough for a controlled first version but realistic enough to support operational analysis.

Two months are enough to begin answering early business questions:

- hourly demand patterns
- weekday vs weekend differences
- pickup and dropoff zone activity
- route-level demand
- revenue and trip efficiency

The zone lookup file is required because the trip files contain location IDs, not readable zone names.

## Why Yellow Taxi First

Yellow Taxi is a good first scope because it has rich trip, fare, distance, pickup, and dropoff fields.

Starting with one taxi type keeps the pipeline easier to inspect while I build the ingestion and BigQuery workflow.

Green Taxi, For-Hire Vehicle, and High Volume For-Hire Vehicle data are out of scope for this version.

## Cost Control

The current version uses two months of data to keep BigQuery usage low.

Cost-control rules:

- load only selected files first
- avoid repeated full scans of raw tables
- create smaller summary tables before connecting Tableau
- expand to 12 months only after the two-month pipeline works

## Future Expansion

After this version works, the project can expand to a full 12-month period.

Recommended final expansion:

```text
yellow_tripdata_2025-01.parquet
through
yellow_tripdata_2025-12.parquet
```

Using a full calendar year is better for seasonality, but it should come after the pipeline is working reliably.

## Data Dictionary

Official Yellow Taxi data dictionary:

```text
https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
```

Important fields used by this version:

- `tpep_pickup_datetime`
- `tpep_dropoff_datetime`
- `passenger_count`
- `trip_distance`
- `PULocationID`
- `DOLocationID`
- `payment_type`
- `fare_amount`
- `tip_amount`
- `tolls_amount`
- `total_amount`
- `congestion_surcharge`
- `airport_fee`
- `cbd_congestion_fee`
