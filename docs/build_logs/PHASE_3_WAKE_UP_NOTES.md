# Phase 3 Wake-Up Notes

This note summarizes the overnight Phase 3 work.

## What Was Improved

The original Tableau draft looked cramped and plain because it used Tableau default formatting and a small dashboard canvas.

To fix the direction, I created a browser dashboard preview:

```text
dashboard_preview/index.html
```

This preview is not the final Tableau workbook. It is a layout reference for the Tableau dashboard.

## What The New Dashboard Preview Includes

- KPI cards
- short decision summary
- Fleet priority zone ranking
- Borough trips vs revenue comparison
- Capacity pressure hotspots
- Pickup volume by hour
- Top revenue zones
- Highest revenue per trip zones
- High-volume low-efficiency route alerts
- Top revenue routes
- recommendation panel

## New Documentation Added

```text
tableau/TABLEAU_REBUILD_GUIDE.md
```

Explains how to rebuild the Tableau version:

- which data source to use
- which fields go into each worksheet
- what filters to add
- what colors to use
- what each visual means

```text
docs/DASHBOARD_KPI_DICTIONARY.md
```

Defines the dashboard KPIs in business language.

## Important Tableau Note

The Tableau workbook itself was not published or uploaded.

I attempted to improve the open Tableau workbook directly overnight. Tableau Public's dashboard sizing and object controls were not reliable through automation, so I did not keep pushing risky UI changes. The workbook was left open and the accidental dashboard-size change was undone.

What was completed instead:

- a clearer dashboard preview
- small Tableau-ready extracts
- a detailed Tableau rebuild guide
- a KPI dictionary
- rendered dashboard images that can be used as Tableau image assets or screenshots

The next Tableau step should be done together:

```text
Rebuild the Tableau dashboard using the browser preview and Tableau rebuild guide.
```

## Next Session Plan

1. Open the dashboard preview.
2. Open Tableau Public.
3. Set Tableau dashboard size to desktop, ideally `1200 x 900`.
4. Connect to the small files in `tableau/tableau_ready/`.
5. Build KPI cards first.
6. Rebuild the charts one by one using `tableau/TABLEAU_REBUILD_GUIDE.md`.
7. Save or publish only when the user is ready.

Useful rendered assets:

```text
tableau/screenshots/executive_dashboard_preview_render.png
tableau/screenshots/executive_dashboard_preview_render_large.png
```

## How I Explain It

```text
The first Tableau draft proved that the mart data worked. I then created a browser dashboard preview to make the layout clearer before rebuilding it in Tableau. The dashboard focuses on demand, revenue, fleet allocation, and route risk.
```
