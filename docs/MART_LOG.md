# Mart Log

This file records KPI mart creation work.

## Run 1: Hourly Demand Mart

Status: complete.

SQL file:

```text
sql/marts/mart_hourly_demand.sql
```

Output table:

```text
nyc-taxi-project-502819.nyc_taxi_ops.mart_hourly_demand
```

## Grain

One row per:

```text
pickup date + pickup hour + pickup zone
```

## Source Tables

- `fact_trips`
- `dim_zone`
- `dim_date`

## KPIs Included

| KPI field | Meaning |
| --- | --- |
| `trips_per_hour` | Trips starting in that pickup zone during that hour |
| `trips_per_borough_per_hour` | Trips starting in that borough during that hour |
| `peak_hour_demand_index` | System hourly trips compared with average system hourly trips |
| `demand_concentration_by_zone` | Zone share of total trips |
| `demand_volatility_score` | Active-hour demand volatility for the pickup zone |

## Validation Results

| Check | Result |
| --- | ---: |
| Mart rows | 233,408 |
| Minimum pickup date | 2026-04-01 |
| Maximum pickup date | 2026-05-31 |
| Non-positive trip rows | 0 |
| Null peak index rows | 0 |
| Null concentration rows | 0 |

## Example Insight From Preview

The highest hourly-zone trip counts in the preview were concentrated in Manhattan zones such as East Village and Midtown Center.

This is not a final business conclusion yet. It is an early sign that the demand mart is producing interpretable operational outputs.

## Cost Note

The dry run estimated the mart query would process about 243 MB.

This mart is much smaller and more dashboard-friendly than querying the raw trip table directly.

