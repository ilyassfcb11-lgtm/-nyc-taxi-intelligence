SELECT *
FROM {{ ref('fact_trips') }}
WHERE trip_distance <= 0
    OR total_amount <= 0
    OR trip_duration_minutes <= 0
