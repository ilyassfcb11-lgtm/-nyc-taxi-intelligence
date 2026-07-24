# Tableau Rebuild Guide

This guide explains how to rebuild the Tableau dashboard using the browser preview as a reference.

Use the preview as the visual target:

```text
dashboard_preview/index.html
```

## Goal

Build a Tableau dashboard named:

```text
NYC Taxi Operations Command Center
```

The dashboard should answer:

- where taxi demand is strongest
- which zones should get fleet priority
- where revenue is strongest
- where operational pressure exists
- which routes need review
- what a manager should look at next

## Recommended Tableau Dashboard Size

Use a desktop dashboard size:

```text
1200 x 900
```

Why:

```text
The current Tableau draft looks cramped because it uses a small phone-sized range. A desktop canvas gives space for KPI cards, charts, filters, and notes.
```

## Tableau Data Sources

For the easiest rebuild, use the small Tableau-ready extracts in:

```text
tableau/tableau_ready/
```

These files are already reduced to the exact grain needed for each dashboard section.

The full mart exports are still available in:

```text
tableau/exports/
```

Recommended sources:

| Dashboard Section | File |
| --- | --- |
| KPI cards | `tableau_ready/kpi_cards.csv` |
| Top priority zones | `tableau_ready/top_priority_zones_top12.csv` |
| Borough mix | `tableau_ready/borough_trip_revenue_mix.csv` |
| Hourly demand | `tableau_ready/hourly_demand_summary.csv` |
| Pressure hotspots | `tableau_ready/pressure_hotspots_top12.csv` |
| Revenue zones | `tableau_ready/top_revenue_zones_top12.csv` |
| Yield zones | `tableau_ready/highest_revenue_per_trip_zones_top12.csv` |
| Route alerts | `tableau_ready/route_alerts_top12.csv` |
| Top revenue routes | `tableau_ready/top_revenue_routes_top12.csv` |

## Dashboard Layout

Use this layout:

```text
Header
  Dashboard title
  Date scope
  Data status

KPI row
  Total Trips
  Total Revenue
  Manhattan Trip Share
  Busiest Pickup Hour
  Route Alerts
  Zones Monitored

Decision row
  Fleet decision
  Revenue decision
  Operations decision

Main dashboard body
  Left: Top Priority Zones
  Center: Trips vs Revenue by Borough
  Right: Pressure Hotspots
  Full width: Pickup Volume by Hour
  Bottom: Revenue Zones, Yield Zones, Route Alerts
```

## Worksheet 1: Total Trips KPI

Data source:

```text
executive_kpi_cards.csv
```

Filter:

```text
metric = Total Trips
```

Marks:

```text
Text
```

Text:

```text
7.59M
Total Trips
```

Formatting:

- large number
- no gridlines
- no axis
- white background
- blue accent

## Worksheet 2: Total Revenue KPI

Data source:

```text
executive_kpi_cards.csv
```

Filter:

```text
metric = Total Revenue
```

Text:

```text
$230.2M
Total Revenue
```

Formatting:

- large number
- green accent
- no gridlines

## Worksheet 3: Top Priority Zones

Data source:

```text
top_priority_zones.csv
```

Rows:

```text
zone_name
```

Columns:

```text
SUM(fleet_allocation_priority_score)
```

Sort:

```text
Descending by fleet_allocation_priority_score
```

Filter:

```text
Top 10 zones
```

Formatting:

- horizontal bar chart
- blue bars
- show mark labels
- hide unnecessary gridlines
- shorten title to `Top Priority Zones`

Business meaning:

```text
This ranks where the fleet manager should pay attention first.
```

## Worksheet 4: Trips vs Revenue by Borough

Data source:

```text
borough_summary.csv
```

Rows:

```text
borough
```

Columns:

```text
SUM(pickup_trips)
SUM(pickup_revenue)
```

Best Tableau version:

```text
Use two side-by-side horizontal bar charts, one for trips and one for revenue.
```

Formatting:

- teal for trips
- green for revenue
- sort by trips descending
- show labels
- remove row banding

Business meaning:

```text
Manhattan dominates trip volume, while Queens has a stronger revenue share because of airport trips.
```

## Worksheet 5: Pickup Volume by Hour

Data source:

```text
mart_hourly_demand.csv
```

Columns:

```text
pickup_hour
```

Rows:

```text
SUM(trips_per_hour)
```

Chart:

```text
Vertical bar chart
```

Formatting:

- gold bars
- highlight 18:00 as the peak hour if possible
- title: `Pickup Volume by Hour`

Business meaning:

```text
Demand is strongest in late afternoon and evening.
```

## Worksheet 6: Pressure Hotspots

Data source:

```text
mart_operational_kpis.csv
```

Rows:

```text
zone_name
```

Columns:

```text
SUM(capacity_pressure_proxy)
```

Filter:

```text
pickup_trips > 500
```

Sort:

```text
Descending by capacity_pressure_proxy
```

Formatting:

- orange or red bars
- show top 10

Business meaning:

```text
This flags zones where demand pressure may require operational attention.
```

## Worksheet 7: Top Revenue Zones

Data source:

```text
mart_revenue_efficiency.csv
```

Rows:

```text
pickup_zone_name
```

Columns:

```text
SUM(total_revenue)
```

Sort:

```text
Descending by total_revenue
```

Formatting:

- green bars
- show top 10

Business meaning:

```text
This shows which pickup zones contribute the most revenue.
```

## Worksheet 8: Route Alerts

Data source:

```text
mart_route_analysis.csv
```

Filter:

```text
high_volume_low_efficiency_alert = true
```

Rows:

```text
pickup_zone_name
dropoff_zone_name
```

Columns:

```text
SUM(trips)
```

Sort:

```text
Descending by trips
```

Formatting:

- red bars
- show top 10
- title: `High-Volume Low-Efficiency Routes`

Business meaning:

```text
This identifies busy routes that may need operational review.
```

## Filters

Add these filters to the dashboard:

- `borough`
- `service_zone`
- `pickup_hour`

Apply filters to relevant worksheets only.

## Formatting Rules

Use consistent colors:

| Meaning | Color |
| --- | --- |
| Priority | Blue |
| Trips | Teal |
| Revenue | Green |
| Demand timing | Gold |
| Risk or pressure | Red/orange |

Remove:

- unnecessary gridlines
- extra Tableau headers
- raw tables as main visuals
- tiny scrollbars when possible
- repeated labels that do not help stakeholders

Add:

- clear section titles
- clean KPI cards
- short business language
- readable number formatting

## Interview Explanation

If asked how the Tableau dashboard was designed:

```text
I designed the Tableau layer as a stakeholder operations dashboard, not a chart dump. The dashboard starts with executive KPIs, then moves into fleet priority, borough demand and revenue mix, demand timing, revenue efficiency, and route alerts. The layout is based on business decisions: where to position vehicles, where revenue is strongest, and which routes need operational review.
```
