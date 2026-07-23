SELECT *
FROM {{ ref('mart_hourly_demand') }}
WHERE trips_per_hour <= 0
    OR system_hourly_trips <= 0
    OR total_revenue <= 0
