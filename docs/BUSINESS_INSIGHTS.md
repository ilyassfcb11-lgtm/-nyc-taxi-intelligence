# Business Insights

This document summarizes the first findings from the BigQuery marts and Tableau export files.

## Summary

In this data, trip volume is heavily concentrated in Manhattan, but airport zones in Queens generate a larger share of revenue than their trip count suggests. That is why the dashboard looks at demand, revenue, efficiency, and zone pressure instead of using trip count alone.

## Key Metrics

| Metric | Value |
| --- | ---: |
| Total Trips | 7,588,819 |
| Total Revenue | $230,215,316 |
| Zones Monitored | 265 |
| Top Priority Score | 78.5 |

## Insight 1: Manhattan Dominates Trip Demand

Manhattan produced 6,563,944 pickup trips, or about 86.5% of the modeled trip volume.

Why I included this:

```text
Fleet availability must be strongest in Manhattan because that is where most pickup activity happens.
```

## Insight 2: Queens Has Outsized Revenue Because Of Airports

Queens produced 656,540 pickup trips, or about 8.7% of trips, but generated about $44.97M in revenue, or 19.5% of total revenue.

Why I included this:

```text
Airport trips can produce more revenue per trip, so a fleet strategy based only on trip count would undervalue Queens.
```

## Insight 3: Top Priority Zones Are Mostly Manhattan, With JFK Also Critical

The highest fleet allocation priority zones include:

| Rank | Zone | Borough | Priority Score |
| ---: | --- | --- | ---: |
| 1 | Upper East Side South | Manhattan | 78.50 |
| 2 | Midtown Center | Manhattan | 74.21 |
| 3 | Upper East Side North | Manhattan | 73.70 |
| 4 | JFK Airport | Queens | 66.78 |
| 5 | Midtown East | Manhattan | 64.61 |

Why I included this:

```text
The dashboard should recommend both dense Manhattan zones and high-value airport zones.
```

## Insight 4: Evening Demand Is Strongest

The busiest pickup hours are:

| Hour | Trips |
| ---: | ---: |
| 18 | 491,225 |
| 17 | 482,078 |
| 21 | 460,168 |
| 15 | 458,713 |
| 14 | 446,902 |

Why I included this:

```text
Fleet managers should monitor late afternoon and evening vehicle availability closely.
```

## Insight 5: Route Analysis Flags Operational Issues

The route mart contains 250 high-volume, low-efficiency route alerts.

Example flagged routes include:

| Route | Trips |
| --- | ---: |
| Penn Station/Madison Sq West -> Times Sq/Theatre District | 13,309 |
| Lenox Hill East -> Upper East Side North | 12,683 |
| Penn Station/Madison Sq West -> Union Sq | 10,278 |
| Yorkville East -> Upper East Side South | 9,247 |
| Upper East Side South -> Times Sq/Theatre District | 6,843 |

Why I included this:

```text
This adds a route-level view instead of only showing demand by zone.
```

## How I Explain It

If someone asks what the analysis found:

```text
The analysis showed that Manhattan dominates trip volume, while Queens airport zones contribute a larger share of revenue than their trip share. The busiest demand periods are late afternoon and evening. I also built a route mart to flag high-volume routes with weaker efficiency. That is why the dashboard uses several KPI tables instead of one chart.
```
