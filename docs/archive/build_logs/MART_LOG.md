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

This is not a final business conclusion yet. It is an early sign that the demand mart is producing useful outputs.

## Cost Note

The dry run estimated the mart query would process about 243 MB.

This mart is much smaller than querying the raw trip table directly.

## Run 2: Revenue Efficiency Mart

Status: complete.

SQL file:

```text
sql/marts/mart_revenue_efficiency.sql
```

Output table:

```text
nyc-taxi-project-502819.nyc_taxi_ops.mart_revenue_efficiency
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
| `revenue_per_hour` | Total revenue per active pickup hour |
| `revenue_per_trip` | Average revenue per trip |
| `revenue_per_mile` | Revenue per passenger trip mile |
| `revenue_per_minute` | Revenue per passenger trip minute |
| `trips_per_active_hour` | Trip volume per active pickup hour |
| `revenue_concentration_risk` | Zone share of total revenue |
| `average_duration_per_mile` | Minutes per passenger trip mile |
| `congestion_proxy` | Duration-per-mile proxy for slow movement |

## Validation Results

| Check | Result |
| --- | ---: |
| Mart rows | 233,408 |
| Minimum pickup date | 2026-04-01 |
| Maximum pickup date | 2026-05-31 |
| Null revenue per hour rows | 0 |
| Null revenue per trip rows | 0 |
| Null revenue per mile rows | 0 |
| Null revenue per minute rows | 0 |

## Example Insight From Preview

The highest revenue-per-hour rows in the preview were concentrated around JFK Airport.

This makes business sense because airport trips tend to have higher fares and fees.

This is still an early preview, not a final recommendation.

## Cost Note

The dry run estimated the mart query would process about 364 MB.

This mart supports Tableau revenue and efficiency analysis without scanning trip-level fact rows repeatedly.

## Run 3: Route Analysis Mart

Status: complete.

SQL file:

```text
sql/marts/mart_route_analysis.sql
```

Output table:

```text
nyc-taxi-project-502819.nyc_taxi_ops.mart_route_analysis
```

## Grain

One row per:

```text
pickup zone + dropoff zone
```

## Source Tables

- `fact_trips`
- `dim_zone`

## KPIs Included

| KPI field | Meaning |
| --- | --- |
| `trips` | Route trip volume |
| `total_revenue` | Route total revenue |
| `revenue_per_trip` | Average route revenue per trip |
| `revenue_per_mile` | Route revenue per passenger mile |
| `revenue_per_minute` | Route revenue per passenger minute |
| `average_duration_per_mile` | Route minutes per passenger mile |
| `congestion_proxy` | Same as duration per mile |
| `route_productivity_index` | Route revenue per trip compared with system average |
| `route_efficiency_score` | Composite score from revenue per mile and revenue per minute |
| `high_volume_low_efficiency_alert` | Flag for high-volume routes with low efficiency score |

## Validation Results

| Check | Result |
| --- | ---: |
| Route rows | 45,409 |
| Non-positive trip rows | 0 |
| Null revenue per trip rows | 0 |
| Null efficiency score rows | 0 |
| High-volume / low-efficiency route alerts | 250 |

## Example Insight From Preview

The highest-volume routes in the preview were concentrated within Manhattan, especially around Upper East Side and Midtown zones.

This suggests the route mart is producing realistic urban mobility patterns.

## Cost Note

The dry run estimated the mart query would process about 304 MB.

This route mart is much smaller than trip-level data and is better for route analysis.

## Run 4: Operational KPI Mart

Status: complete.

SQL file:

```text
sql/marts/mart_operational_kpis.sql
```

Output table:

```text
nyc-taxi-project-502819.nyc_taxi_ops.mart_operational_kpis
```

## Grain

One row per:

```text
taxi zone
```

## Source Tables

- `fact_trips`
- `dim_zone`

## KPIs Included

| KPI field | Meaning |
| --- | --- |
| `zone_utilization_proxy` | Pickup trips per active pickup hour |
| `peak_load_factor` | Peak hourly pickup trips compared with average hourly pickup trips |
| `capacity_pressure_proxy` | Same as peak load factor for the current version |
| `operational_imbalance_score` | Pickup/dropoff imbalance by zone |
| `zone_efficiency_score` | Zone revenue efficiency index from revenue per mile and minute |
| `fleet_allocation_priority_score` | Weighted 0-100 score for fleet attention |

## Fleet Priority Formula

```text
100 * (
  0.40 * demand_score
  + 0.25 * utilization_score
  + 0.20 * efficiency_score
  + 0.15 * pressure_score
)
```

Component scores are normalized and capped to reduce distortion from low-volume outlier zones.

## Validation Results

| Check | Result |
| --- | ---: |
| Zone rows | 265 |
| Negative pickup rows | 0 |
| Negative dropoff rows | 0 |
| Null priority score rows | 0 |
| Null active imbalance rows | 0 |

## Example Insight From Preview

The highest fleet allocation priority scores were concentrated in major Manhattan zones such as Upper East Side South, Midtown Center, and Upper East Side North, with JFK Airport also ranking highly.

This matches the expected pattern: these areas combine high demand, strong utilization, or important movement imbalance.

## Cost Note

The dry run estimated the mart query would process about 425 MB.

This zone-level mart gives Tableau a compact table instead of scanning trip-level data repeatedly.
