SELECT *
FROM {{ ref('mart_revenue_efficiency') }}
WHERE trips <= 0
    OR total_revenue <= 0
    OR total_trip_miles <= 0
    OR total_trip_minutes <= 0
