# Core Model Log

This file records Phase 2 core modeling work.

## Run 1: Create Fact And Dimension Tables

Status: complete.

SQL files:

| File | Output table |
| --- | --- |
| `sql/core/fact_trips.sql` | `fact_trips` |
| `sql/core/dim_zone.sql` | `dim_zone` |
| `sql/core/dim_date.sql` | `dim_date` |

BigQuery destination:

```text
nyc-taxi-project-502819.nyc_taxi_ops
```

## Tables Created

| Table | Rows | Meaning |
| --- | ---: | --- |
| `fact_trips` | 7,588,819 | One cleaned taxi trip per row |
| `dim_zone` | 265 | One taxi zone per row |
| `dim_date` | 61 | One calendar date per row for April-May 2026 |

## Why This Layer Exists

Staging tables are the first cleaned version of raw data.

Core model tables organize the cleaned data into a business-friendly analytics model:

- `fact_trips` stores trip events and numeric measures
- `dim_zone` stores zone context
- `dim_date` stores calendar context

This prepares the project for KPI marts without forcing Tableau to query raw or staging tables directly.

## Validation Results

Core row counts:

| Table | Rows |
| --- | ---: |
| `fact_trips` | 7,588,819 |
| `dim_zone` | 265 |
| `dim_date` | 61 |

Zone join validation:

| Check | Result |
| --- | ---: |
| Missing pickup zone matches | 0 |
| Missing dropoff zone matches | 0 |

## Cost Note

Creating `fact_trips` scanned the staged trips table once.

Future KPI tables should query `fact_trips`, `dim_zone`, and `dim_date` instead of raw tables.

