# Dashboard Preview

This folder contains the published browser dashboard.

I used this version to present the BI dashboard online. The Tableau folder still contains Tableau-ready extracts and screenshots, while this folder powers the public GitHub Pages dashboard.

Live version:

```text
https://ilyassfcb11-lgtm.github.io/nyc-taxi-intelligence/
```

![Dashboard preview](../tableau/screenshots/dashboard_preview_phase3_polish_desktop.png)

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
