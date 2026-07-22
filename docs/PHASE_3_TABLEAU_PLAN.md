# Phase 3 Tableau Plan

Phase 3 turns the BigQuery KPI marts into a Tableau dashboard.

The goal is not just to make charts. The goal is to tell a clear operations story:

```text
Where is taxi demand highest?
When is demand highest?
Which areas are most efficient?
Which routes need attention?
Where should fleet managers prioritize vehicles?
```

## What Tableau Will Connect To

Tableau should connect to the BigQuery mart tables, not the raw table.

BigQuery dataset:

```text
nyc-taxi-project-502819.nyc_taxi_ops
```

Tables to use:

- `mart_hourly_demand`
- `mart_revenue_efficiency`
- `mart_route_analysis`
- `mart_operational_kpis`

## Why We Use The Mart Tables

The raw table has millions of rows and is too detailed for dashboard work.

The mart tables are already summarized for business questions. This makes Tableau:

- easier to build
- faster to use
- cheaper in BigQuery
- easier to explain in interviews

## Dashboard Page 1: Executive Overview

Business question:

```text
What is happening overall in the taxi system?
```

Recommended source table:

```text
mart_operational_kpis
```

Recommended views:

- Top zones by fleet allocation priority score.
- Total pickup trips by borough.
- Total pickup revenue by borough.
- Highest demand zones.
- Highest pressure zones.

Important fields:

- `borough`
- `zone_name`
- `pickup_trips`
- `pickup_revenue`
- `fleet_allocation_priority_score`
- `zone_utilization_proxy`
- `capacity_pressure_proxy`

Why this page matters:

This page gives a manager the first answer quickly: which zones deserve attention.

## Dashboard Page 2: Demand Patterns

Business question:

```text
Where and when is taxi demand highest?
```

Recommended source table:

```text
mart_hourly_demand
```

Recommended views:

- Trips by pickup hour.
- Trips by borough.
- Trips by zone.
- Weekday vs weekend demand.
- Peak hour demand index over time.

Important fields:

- `pickup_date`
- `pickup_hour`
- `pickup_borough`
- `pickup_zone_name`
- `day_name`
- `is_weekend`
- `trips_per_hour`
- `trips_per_borough_per_hour`
- `peak_hour_demand_index`
- `demand_concentration_by_zone`

Why this page matters:

This page shows when and where the taxi system is busiest.

## Dashboard Page 3: Revenue And Efficiency

Business question:

```text
Which zones generate revenue efficiently?
```

Recommended source table:

```text
mart_revenue_efficiency
```

Recommended views:

- Revenue per hour by zone.
- Revenue per trip by zone.
- Revenue per mile by zone.
- Revenue per minute by zone.
- Congestion proxy by zone.

Important fields:

- `pickup_date`
- `pickup_hour`
- `pickup_borough`
- `pickup_zone_name`
- `trips`
- `total_revenue`
- `revenue_per_hour`
- `revenue_per_trip`
- `revenue_per_mile`
- `revenue_per_minute`
- `congestion_proxy`

Why this page matters:

High demand is not always the same as high efficiency. This page helps separate busy zones from productive zones.

## Dashboard Page 4: Route Analysis

Business question:

```text
Which pickup-to-dropoff routes perform best or need attention?
```

Recommended source table:

```text
mart_route_analysis
```

Recommended views:

- Top routes by trip volume.
- Top routes by total revenue.
- Route efficiency score.
- High-volume low-efficiency route alerts.

Important fields:

- `pickup_borough`
- `pickup_zone_name`
- `dropoff_borough`
- `dropoff_zone_name`
- `trips`
- `total_revenue`
- `revenue_per_trip`
- `revenue_per_mile`
- `revenue_per_minute`
- `route_productivity_index`
- `route_efficiency_score`
- `high_volume_low_efficiency_alert`

Why this page matters:

This page moves from zone-level analysis to movement analysis. It helps explain where taxis are going, not only where trips start.

## Dashboard Page 5: Fleet Allocation

Business question:

```text
Where should fleet managers prioritize vehicle availability?
```

Recommended source table:

```text
mart_operational_kpis
```

Recommended views:

- Ranked list of priority zones.
- Pickup/dropoff imbalance by zone.
- Demand share by zone.
- Utilization index by zone.
- Efficiency score by zone.

Important fields:

- `borough`
- `zone_name`
- `pickup_trips`
- `dropoff_trips`
- `demand_share`
- `zone_utilization_proxy`
- `operational_imbalance_score`
- `zone_efficiency_score`
- `fleet_allocation_priority_score`

Why this page matters:

This is the most operations-focused page. It turns the analysis into a recommendation.

## First Tableau Build Order

Build the workbook in this order:

1. Connect Tableau to BigQuery.
2. Add the four mart tables as data sources.
3. Build one simple worksheet from `mart_operational_kpis`.
4. Build the Executive Overview dashboard first.
5. Add Demand Patterns.
6. Add Revenue And Efficiency.
7. Add Route Analysis.
8. Add Fleet Allocation.
9. Write 3 to 5 business insights.

## Beginner Explanation

A worksheet is one chart.

A dashboard is a page made from multiple worksheets.

A data source is the table Tableau reads from.

A mart is a prepared table made for one type of analysis.

So the flow is:

```text
BigQuery mart table
  -> Tableau data source
  -> Tableau worksheet
  -> Tableau dashboard
  -> business insight
```

## Interview Answer

If someone asks why Tableau uses mart tables instead of raw data:

```text
I designed the dashboard on top of KPI mart tables instead of raw trip records. The marts are already cleaned, modeled, and summarized at the correct grain for each analysis. This improves dashboard performance, lowers BigQuery query cost, and reduces the risk of incorrect calculations in Tableau.
```

## Phase 3 Completion Criteria

Phase 3 is complete when the project has:

- A Tableau workbook connected to the BigQuery mart tables.
- Dashboard pages for demand, revenue, routes, and fleet allocation.
- Screenshots or exports saved in the project.
- Business insights documented in the README or a separate insight document.
