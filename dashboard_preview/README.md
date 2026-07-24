# Dashboard Preview

This folder contains a browser version of the taxi dashboard.

I used it to design the dashboard layout before rebuilding the same idea in Tableau. It is easier to control spacing, colors, and layout in HTML/CSS first, then use that as a reference for the Tableau version.

Live version:

```text
https://ilyassfcb11-lgtm.github.io/nyc-taxi-intelligence/
```

The preview includes:

- summary KPI cards
- top pickup zones
- borough trip and revenue comparison
- capacity pressure hotspots
- hourly demand pattern
- revenue efficiency views
- high-volume route alerts

Open locally:

```text
dashboard_preview/index.html
```

The dashboard numbers come from the BigQuery/dbt exports in:

```text
tableau/exports/
```

Saved screenshots are in:

```text
tableau/screenshots/dashboard_preview_phase3_polish_desktop.png
tableau/screenshots/dashboard_preview_phase3_polish_mobile.png
```
