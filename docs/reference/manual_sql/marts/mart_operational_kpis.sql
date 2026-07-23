-- Create the operational KPI mart.
--
-- Grain:
-- One row per taxi zone.
--
-- Source tables:
-- fact_trips, dim_zone

CREATE OR REPLACE TABLE `nyc-taxi-project-502819.nyc_taxi_ops.mart_operational_kpis`
CLUSTER BY borough, location_id
AS
WITH hourly_pickups AS (
    SELECT
        pickup_location_id AS location_id,
        pickup_date,
        pickup_hour,
        COUNT(*) AS hourly_pickup_trips
    FROM `nyc-taxi-project-502819.nyc_taxi_ops.fact_trips`
    GROUP BY pickup_location_id, pickup_date, pickup_hour
),

pickup_metrics AS (
    SELECT
        f.pickup_location_id AS location_id,
        COUNT(*) AS pickup_trips,
        SUM(f.total_amount) AS pickup_revenue,
        SUM(f.trip_distance) AS pickup_trip_miles,
        SUM(f.trip_duration_minutes) AS pickup_trip_minutes,
        COUNT(DISTINCT CONCAT(CAST(f.pickup_date AS STRING), '-', CAST(f.pickup_hour AS STRING)))
            AS active_pickup_hours
    FROM `nyc-taxi-project-502819.nyc_taxi_ops.fact_trips` AS f
    GROUP BY f.pickup_location_id
),

dropoff_metrics AS (
    SELECT
        dropoff_location_id AS location_id,
        COUNT(*) AS dropoff_trips
    FROM `nyc-taxi-project-502819.nyc_taxi_ops.fact_trips`
    GROUP BY dropoff_location_id
),

hourly_zone_metrics AS (
    SELECT
        location_id,
        MAX(hourly_pickup_trips) AS peak_hourly_trips,
        AVG(hourly_pickup_trips) AS average_hourly_trips,
        SAFE_DIVIDE(STDDEV_POP(hourly_pickup_trips), AVG(hourly_pickup_trips))
            AS demand_volatility_score
    FROM hourly_pickups
    GROUP BY location_id
),

zone_base AS (
    SELECT
        z.location_id,
        z.borough,
        z.zone_name,
        z.service_zone,
        COALESCE(p.pickup_trips, 0) AS pickup_trips,
        COALESCE(d.dropoff_trips, 0) AS dropoff_trips,
        COALESCE(p.pickup_revenue, 0) AS pickup_revenue,
        COALESCE(p.pickup_trip_miles, 0) AS pickup_trip_miles,
        COALESCE(p.pickup_trip_minutes, 0) AS pickup_trip_minutes,
        COALESCE(p.active_pickup_hours, 0) AS active_pickup_hours,
        h.peak_hourly_trips,
        h.average_hourly_trips,
        h.demand_volatility_score,
        SAFE_DIVIDE(p.pickup_trips, p.active_pickup_hours) AS zone_utilization_proxy,
        SAFE_DIVIDE(h.peak_hourly_trips, h.average_hourly_trips) AS peak_load_factor,
        SAFE_DIVIDE(h.peak_hourly_trips, h.average_hourly_trips) AS capacity_pressure_proxy,
        SAFE_DIVIDE(p.pickup_revenue, p.pickup_trip_miles) AS revenue_per_mile,
        SAFE_DIVIDE(p.pickup_revenue, p.pickup_trip_minutes) AS revenue_per_minute,
        SAFE_DIVIDE(p.pickup_trip_minutes, p.pickup_trip_miles) AS congestion_proxy,
        SAFE_DIVIDE(
            ABS(COALESCE(p.pickup_trips, 0) - COALESCE(d.dropoff_trips, 0)),
            COALESCE(p.pickup_trips, 0) + COALESCE(d.dropoff_trips, 0)
        ) AS operational_imbalance_score
    FROM `nyc-taxi-project-502819.nyc_taxi_ops.dim_zone` AS z
    LEFT JOIN pickup_metrics AS p
        ON z.location_id = p.location_id
    LEFT JOIN dropoff_metrics AS d
        ON z.location_id = d.location_id
    LEFT JOIN hourly_zone_metrics AS h
        ON z.location_id = h.location_id
),

system_totals AS (
    SELECT
        SUM(pickup_trips) AS system_pickup_trips,
        AVG(zone_utilization_proxy) AS average_zone_utilization_proxy,
        AVG(revenue_per_mile) AS average_revenue_per_mile,
        AVG(revenue_per_minute) AS average_revenue_per_minute,
        AVG(capacity_pressure_proxy) AS average_capacity_pressure_proxy
    FROM zone_base
    WHERE pickup_trips > 0
),

normalized_scores AS (
    SELECT
        zone_base.*,
        SAFE_DIVIDE(zone_base.pickup_trips, system_totals.system_pickup_trips)
            AS demand_share,
        SAFE_DIVIDE(zone_base.zone_utilization_proxy, system_totals.average_zone_utilization_proxy)
            AS utilization_index,
        (
            SAFE_DIVIDE(zone_base.revenue_per_mile, system_totals.average_revenue_per_mile)
            + SAFE_DIVIDE(zone_base.revenue_per_minute, system_totals.average_revenue_per_minute)
        ) / 2.0 AS zone_efficiency_score,
        system_totals.average_capacity_pressure_proxy
    FROM zone_base
    CROSS JOIN system_totals
),

priority_scores AS (
    SELECT
        normalized_scores.*,
        SAFE_DIVIDE(
            demand_share,
            MAX(demand_share) OVER ()
        ) AS demand_score,
        SAFE_DIVIDE(
            LEAST(utilization_index, 3.0),
            3.0
        ) AS utilization_score,
        SAFE_DIVIDE(
            LEAST(zone_efficiency_score, 3.0),
            3.0
        ) AS efficiency_score,
        SAFE_DIVIDE(
            LEAST(SAFE_DIVIDE(capacity_pressure_proxy, average_capacity_pressure_proxy), 3.0),
            3.0
        ) AS pressure_score
    FROM normalized_scores
)

SELECT
    location_id,
    borough,
    zone_name,
    service_zone,
    pickup_trips,
    dropoff_trips,
    pickup_revenue,
    pickup_trip_miles,
    pickup_trip_minutes,
    active_pickup_hours,
    peak_hourly_trips,
    average_hourly_trips,
    demand_share,
    demand_volatility_score,
    zone_utilization_proxy,
    peak_load_factor,
    capacity_pressure_proxy,
    revenue_per_mile,
    revenue_per_minute,
    congestion_proxy,
    operational_imbalance_score,
    zone_efficiency_score,
    demand_score,
    utilization_score,
    efficiency_score,
    pressure_score,
    100 * (
        0.40 * COALESCE(demand_score, 0)
        + 0.25 * COALESCE(utilization_score, 0)
        + 0.20 * COALESCE(efficiency_score, 0)
        + 0.15 * COALESCE(pressure_score, 0)
    ) AS fleet_allocation_priority_score
FROM priority_scores;
