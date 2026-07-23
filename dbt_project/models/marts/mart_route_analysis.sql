{{ config(
    cluster_by=["pickup_borough", "dropoff_borough"]
) }}

WITH route_metrics AS (
    SELECT
        f.pickup_location_id,
        pickup_zone.borough AS pickup_borough,
        pickup_zone.zone_name AS pickup_zone_name,
        f.dropoff_location_id,
        dropoff_zone.borough AS dropoff_borough,
        dropoff_zone.zone_name AS dropoff_zone_name,
        COUNT(*) AS trips,
        SUM(f.total_amount) AS total_revenue,
        SUM(f.trip_distance) AS total_trip_miles,
        SUM(f.trip_duration_minutes) AS total_trip_minutes,
        AVG(f.trip_distance) AS average_trip_distance,
        AVG(f.trip_duration_minutes) AS average_trip_duration_minutes,
        SAFE_DIVIDE(SUM(f.total_amount), COUNT(*)) AS revenue_per_trip,
        SAFE_DIVIDE(SUM(f.total_amount), SUM(f.trip_distance)) AS revenue_per_mile,
        SAFE_DIVIDE(SUM(f.total_amount), SUM(f.trip_duration_minutes)) AS revenue_per_minute,
        SAFE_DIVIDE(SUM(f.trip_duration_minutes), SUM(f.trip_distance)) AS average_duration_per_mile
    FROM {{ ref('fact_trips') }} AS f
    INNER JOIN {{ ref('dim_zone') }} AS pickup_zone
        ON f.pickup_location_id = pickup_zone.location_id
    INNER JOIN {{ ref('dim_zone') }} AS dropoff_zone
        ON f.dropoff_location_id = dropoff_zone.location_id
    GROUP BY
        f.pickup_location_id,
        pickup_zone.borough,
        pickup_zone.zone_name,
        f.dropoff_location_id,
        dropoff_zone.borough,
        dropoff_zone.zone_name
),

system_averages AS (
    SELECT
        SAFE_DIVIDE(SUM(total_revenue), SUM(trips)) AS system_revenue_per_trip,
        SAFE_DIVIDE(SUM(total_revenue), SUM(total_trip_miles)) AS system_revenue_per_mile,
        SAFE_DIVIDE(SUM(total_revenue), SUM(total_trip_minutes)) AS system_revenue_per_minute
    FROM route_metrics
),

route_scoring AS (
    SELECT
        route_metrics.*,
        SAFE_DIVIDE(route_metrics.revenue_per_trip, system_averages.system_revenue_per_trip)
            AS route_productivity_index,
        (
            SAFE_DIVIDE(route_metrics.revenue_per_mile, system_averages.system_revenue_per_mile)
            + SAFE_DIVIDE(route_metrics.revenue_per_minute, system_averages.system_revenue_per_minute)
        ) / 2.0 AS route_efficiency_score
    FROM route_metrics
    CROSS JOIN system_averages
)

SELECT
    pickup_location_id,
    pickup_borough,
    pickup_zone_name,
    dropoff_location_id,
    dropoff_borough,
    dropoff_zone_name,
    trips,
    total_revenue,
    total_trip_miles,
    total_trip_minutes,
    average_trip_distance,
    average_trip_duration_minutes,
    revenue_per_trip,
    revenue_per_mile,
    revenue_per_minute,
    average_duration_per_mile,
    average_duration_per_mile AS congestion_proxy,
    route_productivity_index,
    route_efficiency_score,
    trips >= 100
        AND route_efficiency_score < 0.85 AS high_volume_low_efficiency_alert
FROM route_scoring

