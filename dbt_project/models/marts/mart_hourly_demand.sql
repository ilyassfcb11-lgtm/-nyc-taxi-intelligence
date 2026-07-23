{{ config(
    partition_by={"field": "pickup_date", "data_type": "date"},
    cluster_by=["pickup_borough", "pickup_location_id"]
) }}

WITH hourly_zone_demand AS (
    SELECT
        f.pickup_date,
        f.pickup_hour,
        f.pickup_location_id,
        z.borough AS pickup_borough,
        z.zone_name AS pickup_zone_name,
        d.day_name,
        d.is_weekend,
        COUNT(*) AS trips,
        SUM(f.total_amount) AS total_revenue
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

system_hourly_demand AS (
    SELECT
        pickup_date,
        pickup_hour,
        SUM(trips) AS system_hourly_trips
    FROM hourly_zone_demand
    GROUP BY pickup_date, pickup_hour
),

borough_hourly_demand AS (
    SELECT
        pickup_date,
        pickup_hour,
        pickup_borough,
        SUM(trips) AS borough_hourly_trips
    FROM hourly_zone_demand
    GROUP BY pickup_date, pickup_hour, pickup_borough
),

system_average_hourly_demand AS (
    SELECT
        AVG(system_hourly_trips) AS average_system_hourly_trips
    FROM system_hourly_demand
),

zone_total_demand AS (
    SELECT
        pickup_location_id,
        SUM(trips) AS zone_total_trips
    FROM hourly_zone_demand
    GROUP BY pickup_location_id
),

system_total_demand AS (
    SELECT
        SUM(trips) AS total_trips
    FROM hourly_zone_demand
),

zone_active_hour_volatility AS (
    SELECT
        pickup_location_id,
        SAFE_DIVIDE(STDDEV_POP(trips), AVG(trips)) AS demand_volatility_score
    FROM hourly_zone_demand
    GROUP BY pickup_location_id
)

SELECT
    h.pickup_date,
    h.pickup_hour,
    h.pickup_location_id,
    h.pickup_borough,
    h.pickup_zone_name,
    h.day_name,
    h.is_weekend,
    h.trips AS trips_per_hour,
    b.borough_hourly_trips AS trips_per_borough_per_hour,
    s.system_hourly_trips,
    SAFE_DIVIDE(s.system_hourly_trips, a.average_system_hourly_trips)
        AS peak_hour_demand_index,
    SAFE_DIVIDE(z.zone_total_trips, t.total_trips)
        AS demand_concentration_by_zone,
    v.demand_volatility_score,
    h.total_revenue
FROM hourly_zone_demand AS h
INNER JOIN system_hourly_demand AS s
    ON h.pickup_date = s.pickup_date
    AND h.pickup_hour = s.pickup_hour
INNER JOIN borough_hourly_demand AS b
    ON h.pickup_date = b.pickup_date
    AND h.pickup_hour = b.pickup_hour
    AND h.pickup_borough = b.pickup_borough
CROSS JOIN system_average_hourly_demand AS a
INNER JOIN zone_total_demand AS z
    ON h.pickup_location_id = z.pickup_location_id
CROSS JOIN system_total_demand AS t
INNER JOIN zone_active_hour_volatility AS v
    ON h.pickup_location_id = v.pickup_location_id

