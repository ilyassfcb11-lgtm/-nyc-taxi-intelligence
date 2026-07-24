# Tableau Build Log

This file documents the Tableau dashboard build step by step.

## Dashboard Goal

The Tableau workbook is the native BI dashboard version of the project:

```text
NYC Taxi Operations Command Center
```

The goal is to help a fleet operations manager understand:

- where demand is concentrated
- which boroughs produce the most trips and revenue
- which zones need operational attention
- where vehicles may need to be prioritized

## Data Used So Far

The first Tableau draft uses:

```text
tableau/exports/mart_operational_kpis.csv
```

This CSV came from the BigQuery mart:

```text
nyc-taxi-project-502819.nyc_taxi_ops.mart_operational_kpis
```

## Worksheets Built

### Top Priority Zones

Shows the zones with the highest `fleet_allocation_priority_score`.

Why it matters:

```text
This helps identify where fleet managers should pay attention first.
```

### Pickup Trips by Borough

Shows total pickup trips by borough.

Why it matters:

```text
This shows where taxi demand is concentrated geographically.
```

### Pickup Revenue by Borough

Shows pickup revenue by borough.

Why it matters:

```text
This separates revenue contribution from trip volume.
```

### Operational Imbalance by Zone

Shows zones with high pickup/dropoff imbalance.

Why it matters:

```text
This helps identify zones where supply and demand may not be balanced.
```

### KPI Total Trips

Shows total cleaned trips in the modeled dashboard layer.

Why it matters:

```text
This gives the viewer quick context for the size of the analysis.
```

## Dashboard Built

The first dashboard tab is:

```text
Executive Overview
```

Current screenshot:

```text
tableau/screenshots/executive_overview_work_in_progress.png
```

## What Is Not Finished Yet

This is not final yet.

Next Tableau tasks:

- Add KPI cards for total revenue, zones monitored, and top priority score.
- Improve spacing and colors.
- Add filters for borough and service zone.
- Build the Demand Patterns page.
- Build the Revenue and Efficiency page.
- Build the Route Performance page.
- Publish only after the dashboard is ready to share.

## Dashboard Design Target

The dashboard layout reference is now in:

```text
dashboard_preview/
```

This preview is more complete than the first Tableau draft. It includes:

- KPI cards
- short decision summary
- fleet priority ranking
- borough trip and revenue mix
- capacity pressure hotspots
- hourly demand curve
- revenue efficiency views
- route alert list

The next Tableau build should use this preview as the layout reference.

## Tableau Rebuild Notes

A detailed rebuild guide has been added:

```text
docs/archive/tableau/TABLEAU_REBUILD_GUIDE.md
```

This guide documents the recommended worksheets, fields, filters, colors, and chart meanings for the Tableau dashboard.

## Tableau-Ready Extracts

Small, focused CSV extracts were created in:

```text
tableau/tableau_ready/
```

These are designed to make the Tableau rebuild faster than using the large full mart exports directly.

## Automation Note

The open Tableau Public workbook was not published or uploaded.

Tableau Public's dashboard sizing and dashboard-object controls were not reliable through automated UI control, so risky in-app edits were stopped. The next native Tableau build should be done interactively using the preview and rebuild guide.

## Rendered Dashboard Asset

A rendered image of the dashboard preview was saved for presentation and Tableau image-object use:

```text
tableau/screenshots/executive_dashboard_preview_render.png
tableau/screenshots/executive_dashboard_preview_render_large.png
```

The HTML preview now includes static chart fallback markup, so dashboard sections appear even in renderers that do not run JavaScript.

## Phase 3 Preview Update

The browser dashboard preview was tightened into a clearer operations layout.

Changes:

- shortened the hero copy
- added an operating signal ribbon
- changed the status badge to show `45 dbt tests passed`
- tightened typography and card spacing
- improved desktop layout density
- fixed mobile horizontal overflow caused by long dashboard labels

Responsive validation:

```text
Desktop 1440px: no horizontal overflow
Mobile 390px: no horizontal overflow
```

Saved screenshots:

```text
tableau/screenshots/dashboard_preview_phase3_polish_desktop.png
tableau/screenshots/dashboard_preview_phase3_polish_mobile.png
```

## How I Explain It

If asked what was built in Tableau:

```text
I built the visualization layer on top of KPI mart tables exported from BigQuery. The first Tableau dashboard shows priority zones, borough-level demand and revenue, operational imbalance, and a total-trip KPI card. The dashboard is meant to support fleet allocation decisions instead of only showing raw charts.
```
