# KPI Definitions

This document defines the KPIs I used for the taxi dashboard.

These definitions are the business logic behind the SQL mart tables.

## KPI Design Principles

Good KPIs should be:

- clearly defined
- tied to a business question
- calculated from trusted modeled tables
- easy to explain
- honest about limitations

For this project, KPI SQL should use:

- `fact_trips`
- `dim_zone`
- `dim_date`

Raw tables should not be used directly for dashboards.

## Demand KPIs

### 1. Trips Per Hour

Formula:

```text
count of trips grouped by pickup date and pickup hour
```

Definition:

Number of completed valid taxi trips that started during each hour.

Business meaning:

Shows when taxi demand is highest during the day.

Why it matters:

Useful for fleet scheduling, driver availability planning, and identifying peak operating periods.

Limitations:

This measures completed trips, not unmet demand. It does not show passengers who wanted a taxi but could not get one.

### 2. Trips Per Borough Per Hour

Formula:

```text
count of trips grouped by pickup borough, pickup date, and pickup hour
```

Definition:

Number of valid trips starting in each borough during each hour.

Business meaning:

Shows where and when demand concentrates geographically.

Why it matters:

Helps compare borough-level demand patterns and supports fleet positioning decisions.

Limitations:

Uses pickup borough from the zone lookup. It does not directly show vehicle supply or wait time.

### 3. Peak Hour Demand Index

Formula:

```text
hourly trips / average hourly trips for the comparison period
```

Definition:

Index showing how much higher or lower an hour's demand is compared with average hourly demand.

Business meaning:

Values above 1 indicate above-average demand. Values below 1 indicate below-average demand.

Why it matters:

Helps identify hours that require extra operational attention.

Limitations:

The index depends on the comparison period. Two months of data will not capture full seasonality.

### 4. Weekend Vs Weekday Demand Shift

Formula:

```text
average weekend hourly trips - average weekday hourly trips
```

Alternative percentage formula:

```text
(average weekend hourly trips - average weekday hourly trips) / average weekday hourly trips
```

Definition:

Difference between weekend and weekday demand levels.

Business meaning:

Shows whether demand shifts meaningfully on Saturday and Sunday.

Why it matters:

Useful for weekend staffing, vehicle positioning, and service planning.

Limitations:

Weekend behavior can be affected by holidays, weather, events, and tourism. Those factors are not included yet.

### 5. Demand Concentration By Zone

Formula:

```text
zone trips / total trips
```

Definition:

Share of total trips that start in a pickup zone.

Business meaning:

Shows how much demand is concentrated in specific zones.

Why it matters:

High concentration may reveal major demand hubs and dependency on a small number of zones.

Limitations:

High trip share does not automatically mean high profitability or efficiency.

### 6. Demand Volatility Score

Formula:

```text
standard deviation of hourly trips / average hourly trips
```

Definition:

Measures how unstable hourly demand is for a zone or borough.

Business meaning:

Higher values indicate more unpredictable demand.

Why it matters:

Volatile demand is harder to plan for and may require flexible fleet allocation.

Limitations:

Volatility can be distorted by small zones with low trip counts.

## Productivity KPIs

### 7. Revenue Per Hour

Formula:

```text
sum(total_amount) / number of pickup hours
```

Definition:

Total taxi revenue generated per operating hour in a group.

Business meaning:

Shows how productive a time period, zone, or route is in revenue terms.

Why it matters:

Useful for comparing the revenue potential of different operating windows.

Limitations:

Uses trip revenue, not driver profit. It does not include empty driving time or operating cost.

### 8. Revenue Per Trip

Formula:

```text
sum(total_amount) / count of trips
```

Definition:

Average revenue generated per trip.

Business meaning:

Shows the typical value of a completed trip.

Why it matters:

Useful for identifying high-value zones, routes, or time periods.

Limitations:

Can be influenced by airport fees, tolls, tips, and unusually long trips.

### 9. Revenue Per Mile

Formula:

```text
sum(total_amount) / sum(trip_distance)
```

Definition:

Revenue generated for each passenger trip mile.

Business meaning:

Shows how efficiently trip distance converts into revenue.

Why it matters:

Useful for identifying productive routes and comparing short dense trips against longer trips.

Limitations:

Only uses passenger trip distance. It does not include deadhead miles, meaning miles driven without a passenger.

### 10. Revenue Per Minute

Formula:

```text
sum(total_amount) / sum(trip_duration_minutes)
```

Definition:

Revenue generated per passenger trip minute.

Business meaning:

Shows how efficiently trip time converts into revenue.

Why it matters:

Useful in congested areas where long trip times may reduce productivity.

Limitations:

Trip duration is only passenger time. It does not include time spent waiting for the next passenger.

### 11. Trips Per Active Hour

Formula:

```text
count of trips / count of distinct pickup hours with at least one trip
```

Definition:

Average number of trips handled during active operating hours.

Business meaning:

Measures activity density during periods when demand exists.

Why it matters:

Useful for comparing utilization across zones or boroughs.

Limitations:

This is a demand-side proxy. It does not identify how many vehicles were actually active.

### 12. Revenue Concentration Risk

Formula:

```text
top N zones revenue / total revenue
```

Definition:

Share of revenue generated by the highest-revenue zones.

Business meaning:

Shows whether revenue depends heavily on a small number of zones.

Why it matters:

High concentration can create operational risk if demand changes in those zones.

Limitations:

Risk interpretation depends on the chosen number of top zones.

## Efficiency KPIs

### 13. Route Efficiency Score

Formula:

```text
normalized revenue per mile and revenue per minute for each pickup-dropoff route
```

Definition:

Composite score comparing route productivity using distance and time efficiency.

Business meaning:

Identifies routes that generate strong revenue relative to distance and time.

Why it matters:

Useful for route-level operational analysis and identifying strong or weak corridors.

Limitations:

This is a proxy score. It does not include driver costs, idle time, or traffic conditions directly.

### 14. Zone Efficiency Score

Formula:

```text
weighted combination of trips, revenue per mile, and revenue per minute by pickup zone
```

Definition:

Composite score showing how efficiently a pickup zone generates useful taxi activity.

Business meaning:

Helps compare zones beyond simple trip volume.

Why it matters:

A high-volume zone is not always the most efficient zone.

Limitations:

Composite scores depend on weighting choices, which should be documented clearly.

### 15. Average Duration Per Mile

Formula:

```text
sum(trip_duration_minutes) / sum(trip_distance)
```

Definition:

Average minutes required to travel one passenger mile.

Business meaning:

Higher values suggest slower movement or congestion.

Why it matters:

Useful for identifying routes or zones where trips take longer per mile.

Limitations:

This is a congestion proxy, not direct traffic-speed data.

### 16. Congestion Proxy

Formula:

```text
average duration per mile by route or zone
```

Definition:

Indicator of likely congestion based on how long trips take relative to distance.

Business meaning:

Higher values may indicate areas where traffic slows trip completion.

Why it matters:

Congestion can reduce fleet productivity and driver availability.

Limitations:

Trip duration can be affected by pickup/dropoff behavior, route choice, and data quality, not only congestion.

### 17. High-Volume / Low-Efficiency Alert

Formula:

```text
high trip volume and below-threshold efficiency score
```

Definition:

Flags zones or routes with high demand but weak efficiency.

Business meaning:

Identifies places that are busy but operationally challenging.

Why it matters:

Useful for deciding which zones or routes need a closer look.

Limitations:

Thresholds must be chosen carefully and should be validated with business context.

## IE / Operations KPIs

### 18. Fleet Allocation Priority Score

Formula:

```text
100 * (
  0.40 * demand_score
  + 0.25 * utilization_score
  + 0.20 * efficiency_score
  + 0.15 * pressure_score
)
```

Definition:

Composite score estimating where fleet attention should be prioritized.

Business meaning:

Ranks zones based on operational importance.

Why it matters:

Connects data analysis to fleet planning and resource allocation.

Limitations:

This is a decision-support proxy, not an optimization model. It does not include real fleet supply, driver shifts, or wait times.

The current implementation normalizes and caps component scores to reduce distortion from small-volume outlier zones.

### 19. Zone Utilization Proxy

Formula:

```text
trips per active hour by pickup zone
```

Definition:

Proxy for how intensely a zone is used during hours with demand.

Business meaning:

Shows which zones consistently generate activity.

Why it matters:

Useful when direct vehicle utilization data is not available.

Limitations:

Does not measure actual taxi occupancy or fleet supply.

### 20. Peak Load Factor

Formula:

```text
peak hourly trips / average hourly trips
```

Definition:

Measures how extreme the peak hour is compared with normal demand.

Business meaning:

Higher values show stronger peak pressure.

Why it matters:

Useful for planning peak-hour fleet availability.

Limitations:

Sensitive to the chosen time period and geographic grouping.

### 21. Operational Imbalance Score

Formula:

```text
absolute difference between pickup trips and dropoff trips by zone / total zone activity
```

Definition:

Measures whether a zone has more pickups than dropoffs or more dropoffs than pickups.

Business meaning:

Shows directional imbalance in taxi movement.

Why it matters:

Zones with imbalance may require repositioning or special fleet planning.

Limitations:

Does not track individual vehicles, so it is a movement proxy.

### 22. Capacity Pressure Proxy

Formula:

```text
peak hourly trips in a zone / average hourly trips in that zone
```

Definition:

Proxy for how much pressure a zone experiences during peak periods.

Business meaning:

Highlights zones where demand spikes sharply.

Why it matters:

Useful for identifying locations that may need more vehicles during short peak windows.

Limitations:

It does not measure actual passenger wait time or vehicle availability.

### 23. Route Productivity Index

Formula:

```text
route revenue per trip compared with system average revenue per trip
```

Alternative formula:

```text
route revenue per mile compared with system average revenue per mile
```

Definition:

Index comparing route productivity against the overall system average.

Business meaning:

Values above 1 indicate routes that outperform the system average.

Why it matters:

Useful for identifying routes with stronger revenue productivity.

Limitations:

Must be interpreted with route volume. A route with very few trips can have an unstable index.

## KPI Implementation Order

The first KPI marts should be built in this order:

1. `mart_hourly_demand`
2. `mart_revenue_efficiency`
3. `mart_route_analysis`
4. `mart_operational_kpis`

Start with simple, transparent formulas before adding composite scores.
