# Architecture

## High-Level Flow

```text
Official NYC TLC files
        |
        v
Local Python scripts
        |
        v
BigQuery raw tables
        |
        v
SQL cleaning and transformations
        |
        v
Business-ready KPI marts
        |
        v
Tableau dashboards
        |
        v
Portfolio writeup and interview story
```

## Source Layer

The project uses official NYC TLC Yellow Taxi trip files and the official Taxi Zone Lookup file.

The trip files contain detailed ride-level records. The zone lookup file translates pickup and dropoff location IDs into readable zones, boroughs, and service zones.

## Ingestion Layer

Python will be used to download selected files and load them into BigQuery.

This is the data engineering part of the project. The goal is to move source data into a cloud warehouse in a controlled and repeatable way.

## Raw Layer

Raw BigQuery tables store source data with minimal changes.

This layer is useful because it preserves the original data before cleaning. If a transformation is wrong later, the project can return to the raw source.

Expected raw tables:

- `raw_taxi_trips`
- `raw_zone_lookup`

## Transformation Layer

SQL will clean, standardize, and reshape the raw data.

At first, this will be done with regular SQL scripts. Later, dbt will organize the same logic into documented and testable models.

Expected modeled tables:

- `stg_trips`
- `stg_zones`
- `fact_trips`
- `dim_zone`
- `dim_date`

## Mart Layer

Mart tables are business-ready summary tables designed for Tableau and analysis.

This helps control BigQuery cost because dashboards should query smaller summary tables instead of scanning large raw trip tables repeatedly.

Expected mart tables:

- `mart_hourly_demand`
- `mart_revenue_efficiency`
- `mart_route_analysis`
- `mart_operational_kpis`

## Visualization Layer

Tableau will connect to the business-ready mart tables.

Expected dashboard pages:

- Executive Overview
- Demand Analysis
- Revenue Efficiency
- Zone and Route Analysis
- Recommendations / Key Findings

## Cost Control

The project will start with two months of data and build summary tables before dashboarding.

Important cost-control habits:

- Avoid repeated full scans of raw trip tables.
- Use selected months for the MVP.
- Query marts instead of raw data in Tableau.
- Preview query cost in BigQuery before running large queries.

