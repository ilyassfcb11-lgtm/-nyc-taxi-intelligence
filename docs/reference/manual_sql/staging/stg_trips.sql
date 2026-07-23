-- Create the first cleaned trip staging table.
--
-- This query keeps the raw table unchanged and writes a new table:
-- nyc-taxi-project-502819.nyc_taxi_ops.stg_trips
--
-- Cleaning rules are documented in docs/CLEANING_RULES.md.

CREATE OR REPLACE TABLE `nyc-taxi-project-502819.nyc_taxi_ops.stg_trips`
PARTITION BY pickup_date
CLUSTER BY pickup_location_id, dropoff_location_id
AS
SELECT
    VendorID AS vendor_id,
    tpep_pickup_datetime AS pickup_datetime,
    tpep_dropoff_datetime AS dropoff_datetime,
    DATE(tpep_pickup_datetime) AS pickup_date,
    EXTRACT(HOUR FROM tpep_pickup_datetime) AS pickup_hour,
    FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime)) AS pickup_month,
    FORMAT_DATE('%A', DATE(tpep_pickup_datetime)) AS day_of_week,
    EXTRACT(DAYOFWEEK FROM DATE(tpep_pickup_datetime)) IN (1, 7) AS is_weekend,
    passenger_count,
    trip_distance,
    RatecodeID AS rate_code_id,
    store_and_fwd_flag,
    PULocationID AS pickup_location_id,
    DOLocationID AS dropoff_location_id,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    Airport_fee AS airport_fee,
    cbd_congestion_fee,
    TIMESTAMP_DIFF(tpep_dropoff_datetime, tpep_pickup_datetime, SECOND) / 60.0
        AS trip_duration_minutes,
    SAFE_DIVIDE(
        trip_distance,
        TIMESTAMP_DIFF(tpep_dropoff_datetime, tpep_pickup_datetime, SECOND) / 3600.0
    ) AS average_speed_mph
FROM `nyc-taxi-project-502819.nyc_taxi_ops.raw_taxi_trips`
WHERE DATE(tpep_pickup_datetime) BETWEEN DATE '2026-04-01' AND DATE '2026-05-31'
    AND tpep_pickup_datetime IS NOT NULL
    AND tpep_dropoff_datetime IS NOT NULL
    AND tpep_dropoff_datetime > tpep_pickup_datetime
    AND trip_distance > 0
    AND total_amount > 0
    AND PULocationID IS NOT NULL
    AND DOLocationID IS NOT NULL;

