# KPI Definitions

This file keeps the dashboard metrics in one place. I used it as the planning sheet before writing the dbt mart SQL, so the formulas stayed consistent across BigQuery, CSV exports, and the dashboard.

The KPI tables are built from the modeled layer:

- `fact_trips`
- `dim_zone`
- `dim_date`

I do not use the raw trip table directly for dashboard metrics. The raw table is useful for rebuilding and checking the pipeline, but the dashboard should use cleaned and modeled data.

## Metric Rules

Before adding a KPI, I checked four things:

- What question does it answer?
- Which table grain does it need?
- Can I calculate it consistently in SQL?
- What can it not tell me?

## Demand Metrics

| KPI | Calculation | Used For | Watch Out |
| --- | --- | --- | --- |
| Trips Per Hour | Count trips by pickup date and pickup hour | Finding the busiest hours | Completed trips do not show unmet demand |
| Trips Per Borough Per Hour | Count trips by borough, date, and hour | Comparing borough demand patterns | Borough comes from the zone lookup, not GPS coordinates |
| Peak Hour Demand Index | Hourly trips divided by average hourly trips | Spotting hours above normal demand | Two months of data does not capture full seasonality |
| Weekend Vs Weekday Demand Shift | Weekend average hourly trips minus weekday average hourly trips | Checking whether demand changes on weekends | Holidays, weather, and events are not included |
| Demand Concentration By Zone | Zone trips divided by total trips | Finding zones that dominate pickup demand | High demand does not always mean high revenue |
| Demand Volatility Score | Standard deviation of hourly trips divided by average hourly trips | Finding zones with unstable demand | Small zones can look volatile because they have low volume |

## Revenue And Productivity Metrics

| KPI | Calculation | Used For | Watch Out |
| --- | --- | --- | --- |
| Revenue Per Hour | Total revenue divided by active pickup hours | Comparing revenue productivity by zone or time | Uses trip revenue, not driver profit |
| Revenue Per Trip | Total revenue divided by trips | Finding higher-value zones or routes | Airport fees, tolls, tips, and long trips can affect it |
| Revenue Per Mile | Total revenue divided by trip distance | Comparing revenue against passenger miles | Does not include empty driving miles |
| Revenue Per Minute | Total revenue divided by trip duration minutes | Comparing revenue against passenger time | Does not include time waiting for the next passenger |
| Trips Per Active Hour | Trips divided by active pickup hours | Comparing activity density | It is a demand proxy, not actual vehicle utilization |
| Revenue Concentration Risk | Revenue from top zones divided by total revenue | Checking whether revenue depends on a few zones | The result depends on how many top zones are included |

## Efficiency And Route Metrics

| KPI | Calculation | Used For | Watch Out |
| --- | --- | --- | --- |
| Route Efficiency Score | Normalized revenue per mile and revenue per minute by route | Comparing route performance | It does not include driver cost, idle time, or live traffic |
| Zone Efficiency Score | Weighted score using trips, revenue per mile, and revenue per minute | Comparing zones beyond trip volume | Composite scores depend on the chosen weights |
| Average Duration Per Mile | Trip duration minutes divided by trip distance | Finding slow routes or zones | It is a congestion proxy, not traffic sensor data |
| Congestion Proxy | Average duration per mile by route or zone | Flagging slower movement | Pickup/dropoff behavior can affect the number |
| High-Volume / Low-Efficiency Alert | High trip volume with below-threshold efficiency score | Finding busy routes or zones that need review | Thresholds should be checked against the data distribution |
| Route Productivity Index | Route revenue per trip compared with system average | Finding routes with stronger revenue productivity | Low-volume routes can have unstable values |

## Operations Metrics

| KPI | Calculation | Used For | Watch Out |
| --- | --- | --- | --- |
| Fleet Allocation Priority Score | `0.40*demand + 0.25*utilization + 0.20*efficiency + 0.15*pressure`, scaled 0-100 | Ranking zones that may need more vehicle attention | This is a decision-support score, not an optimization model |
| Zone Utilization Proxy | Pickup trips per active pickup hour | Finding zones with steady activity | It does not measure actual taxi occupancy or supply |
| Peak Load Factor | Peak hourly trips divided by average hourly trips | Finding zones with sharp demand spikes | Sensitive to time period and grouping |
| Operational Imbalance Score | Absolute pickup/dropoff difference divided by total zone activity | Finding zones with directional imbalance | It does not track individual vehicles |
| Capacity Pressure Proxy | Peak hourly trips in a zone divided by average hourly trips in that zone | Finding short peak windows where demand rises quickly | It does not measure passenger wait time |

## Current Mart Build Order

I built the mart tables in this order:

1. `mart_hourly_demand`
2. `mart_revenue_efficiency`
3. `mart_route_analysis`
4. `mart_operational_kpis`

I started with simple formulas first, then added composite scores after the base metrics were working.
