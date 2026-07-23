# Phase 3 Wake-Up Notes

This note summarizes the overnight Phase 3 work.

## What Was Improved

The original Tableau draft looked cramped and plain because it used Tableau default formatting and a small dashboard canvas.

To fix the direction, the project now has a polished BI dashboard preview:

```text
dashboard_preview/index.html
```

This preview is not the final Tableau workbook. It is the design and business blueprint for the final Tableau dashboard.

## What The New Dashboard Preview Includes

- Executive KPI cards
- Stakeholder decision summary
- Fleet priority zone ranking
- Borough trips vs revenue comparison
- Capacity pressure hotspots
- Pickup volume by hour
- Top revenue zones
- Highest revenue per trip zones
- High-volume low-efficiency route alerts
- Top revenue routes
- Stakeholder recommendation panel

## New Documentation Added

```text
tableau/TABLEAU_REBUILD_GUIDE.md
```

Explains exactly how to rebuild the polished Tableau version:

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

The next Tableau step should be done together:

```text
Rebuild the Tableau dashboard using the polished preview and Tableau rebuild guide.
```

## Next Session Plan

1. Open the polished dashboard preview.
2. Open Tableau Public.
3. Set Tableau dashboard size to desktop, ideally `1200 x 900`.
4. Build KPI cards first.
5. Rebuild the charts one by one using `tableau/TABLEAU_REBUILD_GUIDE.md`.
6. Save or publish only when the user is ready.

## Interview Talking Point

```text
The first Tableau draft proved that the mart data worked. I then created a polished BI dashboard blueprint with stakeholder-focused KPIs, operational recommendations, and clear sections for demand, revenue, fleet allocation, and route risk. This mirrors a real BI workflow: first validate the data, then design the dashboard for decision-making.
```
