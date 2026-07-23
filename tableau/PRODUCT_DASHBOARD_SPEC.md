# Product Dashboard Spec

This dashboard should feel like an operations analytics product, not a static report.

The dashboard is for a fleet operations manager who needs to quickly answer:

```text
Where is demand concentrated?
Which zones need fleet attention?
Where is revenue strong?
Where is the system under pressure?
What action should we take next?
```

## Dashboard Name

```text
NYC Taxi Operations Command Center
```

## Design Direction

Use a clean product dashboard layout:

- Dark or neutral header.
- KPI cards at the top.
- Filters on the left or top.
- Main priority chart in the center.
- Supporting charts on the side or below.
- Short business insight text, not long paragraphs.

Avoid making it look like a PDF report:

- Do not just stack charts vertically.
- Do not use large blocks of explanation.
- Do not show every possible metric at once.
- Do not use raw tables as the main visual.

## Page 1: Executive Overview

Purpose:

```text
Give a fast operational summary of the taxi system.
```

Recommended layout:

```text
Header: NYC Taxi Operations Command Center

KPI cards:
  Total Trips
  Total Revenue
  Zones Monitored
  Top Priority Score

Main visual:
  Top Priority Zones

Supporting visuals:
  Pickup Trips by Borough
  Pickup Revenue by Borough

Filters:
  Borough
  Service Zone
```

Recommended data files:

- `tableau/exports/executive_kpi_cards.csv`
- `tableau/exports/top_priority_zones.csv`
- `tableau/exports/borough_summary.csv`

## Page 2: Demand Patterns

Purpose:

```text
Show when and where demand is highest.
```

Recommended visuals:

- Trips by hour.
- Trips by day of week.
- Peak hour demand index over time.
- Top pickup zones by trips per hour.

Recommended data file:

- `tableau/exports/mart_hourly_demand.csv`

## Page 3: Revenue And Efficiency

Purpose:

```text
Separate busy zones from efficient zones.
```

Recommended visuals:

- Revenue per hour by zone.
- Revenue per trip by zone.
- Revenue per mile by zone.
- Congestion proxy by zone.

Recommended data file:

- `tableau/exports/mart_revenue_efficiency.csv`

## Page 4: Route Performance

Purpose:

```text
Identify high-volume routes and routes with low efficiency.
```

Recommended visuals:

- Top routes by trip volume.
- Top routes by revenue.
- Route efficiency score.
- High-volume low-efficiency route alerts.

Recommended data file:

- `tableau/exports/mart_route_analysis.csv`

## Product-Level KPI Cards

The first dashboard should include these cards:

| KPI | Meaning |
| --- | --- |
| Total Trips | Cleaned trip volume loaded into the modeled layer |
| Total Revenue | Total pickup-zone revenue in the operational mart |
| Zones Monitored | Number of taxi zones included in the operational view |
| Top Priority Score | Highest fleet allocation priority score |

These values are exported in:

```text
tableau/exports/executive_kpi_cards.csv
```

## Dashboard Story

The dashboard should tell this story:

1. Manhattan dominates taxi pickup activity.
2. The highest fleet-priority zones are concentrated in Manhattan, with JFK Airport also important.
3. Demand volume and revenue are related, but not identical.
4. Fleet decisions should use a composite score, not trip count alone.

## Interview Explanation

If someone asks why this is a dashboard and not just charts:

```text
I designed the visualization layer as an operations command center. The dashboard starts with KPI cards for fast executive context, then uses ranked priority views and borough-level comparisons to support fleet allocation decisions. The goal is not only to show charts, but to help a manager decide where vehicles should be prioritized.
```

## Current Build Status

Built in Tableau:

- `Top Priority Zones`
- `Pickup Trips by Borough`
- `Pickup Revenue by Borough`
- `Operational Imbalance by Zone`
- `KPI Total Trips`
- `Executive Overview`
- Dashboard title: `NYC Taxi Operations Command Center`

Saved project artifact:

- `tableau/screenshots/executive_overview_work_in_progress.png`
- `dashboard_preview/` product dashboard design target

Still needed:

- KPI cards for total revenue, zones monitored, and top priority score.
- Borough and service zone filters.
- Better product-style formatting, spacing, and colors.
- Demand, revenue, and route pages.
- Final published Tableau Public link or dashboard screenshots.

Current status:

```text
The first dashboard is a working draft. It proves the mart data is connected and the core operational views exist. The next Tableau work should focus on layout polish and adding the remaining dashboard pages.
```
