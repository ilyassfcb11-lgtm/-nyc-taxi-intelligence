SELECT *
FROM {{ ref('stg_trips') }}
WHERE pickup_datetime IS NULL
    OR dropoff_datetime IS NULL
    OR dropoff_datetime <= pickup_datetime
    OR pickup_date NOT BETWEEN DATE '2026-04-01' AND DATE '2026-05-31'
    OR pickup_location_id IS NULL
    OR dropoff_location_id IS NULL
    OR trip_distance <= 0
    OR total_amount <= 0
    OR trip_duration_minutes <= 0
