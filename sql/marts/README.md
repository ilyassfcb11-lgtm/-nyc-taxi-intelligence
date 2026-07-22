# KPI Mart SQL

KPI mart tables are business-ready summary tables.

They are built from the core model layer:

```text
fact_trips + dim_zone + dim_date
        |
        v
KPI marts
        |
        v
Tableau dashboards
```

## Why Marts Exist

Fact tables can still contain millions of rows.

Mart tables summarize facts into analysis-friendly grains, such as:

- one row per hour and zone
- one row per route
- one row per day and borough

This makes Tableau faster, cheaper, and easier to use.

## First Mart

| Mart | Purpose |
| --- | --- |
| `mart_hourly_demand` | Demand KPIs by pickup date, hour, borough, and zone |
| `mart_revenue_efficiency` | Revenue productivity and time/distance efficiency KPIs |
| `mart_route_analysis` | Route-level productivity, efficiency, and congestion proxy KPIs |
| `mart_operational_kpis` | Zone-level IE and operations KPIs |
