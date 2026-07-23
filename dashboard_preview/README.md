# Dashboard Preview

This folder contains a polished browser preview for the portfolio dashboard.

Purpose:

```text
Create a clean product-dashboard target before final Tableau formatting.
```

The current Tableau workbook proves the data works, but Tableau's default chart styles are plain. This preview shows the intended final design direction for a stakeholder-ready BI dashboard:

- executive KPI cards at the top
- stakeholder decision summary
- ranked operational priority zones
- borough trip and revenue portfolio comparison
- capacity pressure hotspots
- hourly demand pattern
- revenue efficiency and yield views
- high-volume low-efficiency route alerts
- concise operational recommendations

Open:

```text
dashboard_preview/index.html
```

The numbers come from the BigQuery mart exports in:

```text
tableau/exports/
```

## Current Polish Pass

The preview was tightened into a more executive dashboard layout:

- compact KPI row
- operating signal ribbon
- clearer stakeholder decision cards
- improved spacing, shadows, and typography
- responsive desktop and mobile layout fixes
- visible quality gate showing 45 passing dbt tests

Saved screenshots:

```text
tableau/screenshots/dashboard_preview_phase3_polish_desktop.png
tableau/screenshots/dashboard_preview_phase3_polish_mobile.png
```

## Design Purpose

The preview is intentionally more polished than the first Tableau draft.

It should help us rebuild Tableau with a clearer target:

```text
An employer should understand the business value in 10 seconds.
A stakeholder should understand what action to take next.
An interviewer should see the full analytics pipeline behind the dashboard.
```
