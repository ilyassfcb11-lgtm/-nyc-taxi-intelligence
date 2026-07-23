# Data Quality

This document explains how the project checks whether the taxi analytics tables are reliable enough for KPI reporting and dashboard use.

## Current Status

The dbt data quality suite passes:

```text
dbt test --profiles-dir .
PASS=45 WARN=0 ERROR=0 SKIP=0 TOTAL=45
```

This means dbt ran 45 saved quality checks against BigQuery and none failed.

## What Is Being Tested

The tests cover four main quality areas.

| Area | What It Checks | Why It Matters |
| --- | --- | --- |
| Completeness | Required fields are not null | Dashboards and joins need important fields to exist |
| Uniqueness | IDs are unique where expected | Prevents duplicate dimensions and duplicate trip records |
| Relationships | Fact table location IDs exist in `dim_zone` | Proves fact and dimension tables connect correctly |
| Business rules | Clean trip and KPI values stay in valid ranges | Prevents impossible trips or misleading KPI values |

## Completeness Tests

Completeness tests check that important fields are filled in.

Examples:

```text
pickup_datetime is not null
dropoff_datetime is not null
pickup_location_id is not null
dropoff_location_id is not null
total_amount is not null
```

If these fields are missing, the project cannot reliably calculate demand, revenue, trip duration, or route KPIs.

## Uniqueness Tests

Uniqueness tests check that key IDs do not repeat when they should identify one record.

Examples:

```text
fact_trips.trip_id is unique
dim_zone.location_id is unique
dim_date.calendar_date is unique
```

This protects the model from duplicate keys that could inflate dashboard numbers.

## Relationship Tests

Relationship tests check that the fact table connects correctly to the dimension table.

Current relationship checks:

```text
fact_trips.pickup_location_id exists in dim_zone.location_id
fact_trips.dropoff_location_id exists in dim_zone.location_id
```

Beginner explanation:

Every pickup or dropoff zone used in a trip must exist in the taxi zone lookup table. If a trip has a location ID that does not exist in `dim_zone`, route and borough analysis may break or become misleading.

## Business Rule Tests

The project also includes custom SQL tests for business logic.

Current custom tests:

| Test File | Rule |
| --- | --- |
| `assert_stg_trips_cleaning_rules.sql` | Staging trips must stay inside the MVP date window and have valid trip metrics |
| `assert_fact_trips_positive_trip_metrics.sql` | Fact trips must have positive distance, amount, and duration |
| `assert_mart_hourly_demand_positive.sql` | Hourly demand marts must have positive demand and revenue |
| `assert_mart_revenue_efficiency_positive.sql` | Revenue efficiency marts must have positive trip, revenue, mile, and minute totals |
| `assert_mart_operational_score_range.sql` | Fleet priority score must stay between 0 and 100 |

These tests protect the business meaning of the dashboard, not just the database structure.

## How To Run The Tests

From the dbt project folder:

```bash
cd dbt_project
source ../.venv/bin/activate
dbt test --profiles-dir .
```

Expected successful result:

```text
Completed successfully
PASS=45 WARN=0 ERROR=0 SKIP=0 TOTAL=45
```

## What Happens If A Test Fails

If a dbt test fails, dbt returns the name of the failed test.

The next step is to inspect the failed rule:

```text
1. Find the failed test name.
2. Open the matching `schema.yml` rule or SQL file in `dbt_project/tests/`.
3. Run or inspect the SQL to see which rows broke the rule.
4. Decide whether to fix ingestion, cleaning logic, modeling logic, or the test itself.
```

Important:

A failed test is not always bad. Sometimes it reveals a real data issue that should be documented or handled.

## Current Limitations

The current test suite is strong for an MVP, but it is not a complete production monitoring system yet.

Future improvements could include:

- source freshness checks for new monthly TLC files
- row-count comparison between raw and cleaned layers
- accepted value tests for payment type and rate code
- anomaly checks for unusually high revenue or trip distance
- scheduled alerts when a monthly pipeline run fails

## Interview Answer

If asked how data quality is handled in this project:

```text
I use dbt tests to make data quality part of the pipeline. The tests check completeness, uniqueness, relationships between fact and dimension tables, and business rules such as positive trip distance, positive revenue, valid trip duration, and KPI score ranges. This means the pipeline does not only build tables; it also validates that the tables are reliable enough for dashboard reporting.
```
