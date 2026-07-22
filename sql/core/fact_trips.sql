-- Create the core trip fact table.
--
-- One row = one cleaned taxi trip.
--
-- This table uses stg_trips as its source. It keeps foreign keys, timestamps,
-- and numeric measures needed for KPI development.

CREATE OR REPLACE TABLE `nyc-taxi-project-502819.nyc_taxi_ops.fact_trips`
PARTITION BY pickup_date
CLUSTER BY pickup_location_id, dropoff_location_id
AS
SELECT
    FARM_FINGERPRINT(
        CONCAT(
            CAST(vendor_id AS STRING), '|',
            CAST(pickup_datetime AS STRING), '|',
            CAST(dropoff_datetime AS STRING), '|',
            CAST(pickup_location_id AS STRING), '|',
            CAST(dropoff_location_id AS STRING), '|',
            CAST(trip_distance AS STRING), '|',
            CAST(total_amount AS STRING)
        )
    ) AS trip_id,
    pickup_datetime,
    dropoff_datetime,
    pickup_date,
    pickup_hour,
    pickup_month,
    day_of_week,
    is_weekend,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    passenger_count,
    trip_distance,
    trip_duration_minutes,
    average_speed_mph,
    fare_amount,
    tip_amount,
    tolls_amount,
    total_amount,
    congestion_surcharge,
    airport_fee,
    cbd_congestion_fee
FROM `nyc-taxi-project-502819.nyc_taxi_ops.stg_trips`;

