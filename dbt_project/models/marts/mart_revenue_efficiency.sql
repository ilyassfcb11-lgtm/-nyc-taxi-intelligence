{{ config(
    partition_by={"field": "pickup_date", "data_type": "date"},
    cluster_by=["pickup_borough", "pickup_location_id"]
) }}

WITH hourly_zone_metrics AS (
    SELECT
        f.pickup_date,
        f.pickup_hour,
        f.pickup_location_id,
        z.borough AS pickup_borough,
        z.zone_name AS pickup_zone_name,
        d.day_name,
        d.is_weekend,
        COUNT(*) AS trips,
        SUM(f.total_amount) AS total_revenue,
        SUM(f.trip_distance) AS total_trip_miles,
        SUM(f.trip_duration_minutes) AS total_trip_minutes,
        COUNT(DISTINCT CONCAT(CAST(f.pickup_date AS STRING), '-', CAST(f.pickup_hour AS STRING)))
            AS active_hours
    FROM {{ ref('fact_trips') }} AS f
    INNER JOIN {{ ref('dim_zone') }} AS z
        ON f.pickup_location_id = z.location_id
    INNER JOIN {{ ref('dim_date') }} AS d
        ON f.pickup_date = d.calendar_date
    GROUP BY
        f.pickup_date,
        f.pickup_hour,
        f.pickup_location_id,
        z.borough,
        z.zone_name,
        d.day_name,
        d.is_weekend
),

zone_revenue AS (
    SELECT
        pickup_location_id,
        SUM(total_revenue) AS zone_total_revenue
    FROM hourly_zone_metrics
    GROUP BY pickup_location_id
),

system_revenue AS (
    SELECT
        SUM(total_revenue) AS system_total_revenue
    FROM hourly_zone_metrics
)

SELECT
    h.pickup_date,
    h.pickup_hour,
    h.pickup_location_id,
    h.pickup_borough,
    h.pickup_zone_name,
    h.day_name,
    h.is_weekend,
    h.trips,
    h.total_revenue,
    h.total_trip_miles,
    h.total_trip_minutes,
    SAFE_DIVIDE(h.total_revenue, h.active_hours) AS revenue_per_hour,
    SAFE_DIVIDE(h.total_revenue, h.trips) AS revenue_per_trip,
    SAFE_DIVIDE(h.total_revenue, h.total_trip_miles) AS revenue_per_mile,
    SAFE_DIVIDE(h.total_revenue, h.total_trip_minutes) AS revenue_per_minute,
    SAFE_DIVIDE(h.trips, h.active_hours) AS trips_per_active_hour,
    SAFE_DIVIDE(z.zone_total_revenue, s.system_total_revenue) AS revenue_concentration_risk,
    SAFE_DIVIDE(h.total_trip_minutes, h.total_trip_miles) AS average_duration_per_mile,
    SAFE_DIVIDE(h.total_trip_minutes, h.total_trip_miles) AS congestion_proxy
FROM hourly_zone_metrics AS h
INNER JOIN zone_revenue AS z
    ON h.pickup_location_id = z.pickup_location_id
CROSS JOIN system_revenue AS s

