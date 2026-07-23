# Staging SQL

Staging tables are the first cleaned layer after raw data.

The goal is to make raw source data easier and safer to use for KPI queries.

## Tables

| Table | Purpose |
| --- | --- |
| `stg_trips` | Cleaned Yellow Taxi trip records with useful derived fields |
| `stg_zones` | Standardized Taxi Zone Lookup records |

## Why Staging Exists

Raw tables should stay close to the original files.

Staging tables apply the first cleaning and standardization rules:

- filter invalid records
- rename columns for readability
- add useful date and time fields
- create safe derived metrics

## Cost Note

The staging trip table is partitioned by `pickup_date` and clustered by pickup/dropoff location IDs.

This helps later queries scan less data when filtering by date or zone.

