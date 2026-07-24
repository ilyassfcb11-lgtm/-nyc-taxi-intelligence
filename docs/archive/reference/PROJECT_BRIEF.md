# Project Brief

## Project Name

NYC Taxi Operations Intelligence Platform

## Objective

Build a cloud analytics project that turns NYC Yellow Taxi trip data into useful operating metrics.

The project combines data engineering, analytics engineering, and data analysis:

- Data engineering: ingest source files and load raw data into BigQuery.
- Analytics engineering: clean, model, test, and document trusted tables.
- Data analysis: design KPIs, interpret patterns, and explain what the numbers suggest.

## Business Context

Taxi operators, mobility planners, and fleet managers need to understand when demand rises, where trips concentrate, which routes are productive, and where service pressure appears.

I treated the taxi data as an operations problem, not only a charting exercise.

## Main Business Questions

- When and where is taxi demand highest?
- Which pickup and dropoff zones are busiest?
- Which routes are most efficient or profitable?
- Which KPIs best describe operational performance?
- How can fleet allocation decisions be improved?
- How can raw trip records become trusted analysis tables?

## Initial Scope

- Dataset: NYC TLC Yellow Taxi Trip Records.
- Geography reference: official Taxi Zone Lookup.
- Current period: two months of trip data.
- Warehouse: BigQuery.
- Dashboard tool: Tableau.
- Transformation approach: SQL first, dbt later.

## Project Goal

The finished project should show practical work with Python, SQL, BigQuery, KPI design, Tableau, dbt, testing, CI/CD, and clear business explanation.
