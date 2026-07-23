# Tableau-Ready Extracts

This folder contains small CSV files prepared specifically for rebuilding the polished Tableau dashboard.

These are not raw taxi files. They are small, dashboard-focused extracts created from the BigQuery mart exports.

Use these files in Tableau when rebuilding:

| File | Use |
| --- | --- |
| `kpi_cards.csv` | Executive KPI cards |
| `top_priority_zones_top12.csv` | Fleet priority ranking |
| `borough_trip_revenue_mix.csv` | Trips vs revenue by borough |
| `hourly_demand_summary.csv` | Pickup volume by hour |
| `pressure_hotspots_top12.csv` | Capacity pressure hotspots |
| `top_revenue_zones_top12.csv` | Highest revenue zones |
| `highest_revenue_per_trip_zones_top12.csv` | Highest-yield zones |
| `route_alerts_top12.csv` | High-volume low-efficiency routes |
| `top_revenue_routes_top12.csv` | Top routes by revenue |

Why these files exist:

```text
The full mart exports are useful, but they can make Tableau slower and harder for a beginner to build. These focused extracts make the final dashboard faster to build and easier to explain.
```

Interview explanation:

```text
I prepared small Tableau-specific extracts from the BigQuery marts so the dashboard layer works at the correct grain. This keeps Tableau focused on visualization instead of forcing it to perform heavy transformations.
```
