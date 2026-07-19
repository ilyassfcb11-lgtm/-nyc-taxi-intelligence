-- Phase 1 raw ingestion validation queries.
--
-- These queries check whether the raw BigQuery tables loaded correctly.
-- They do not clean or transform the data.
--
-- Cost note:
-- Run validation deliberately. BigQuery charges by data scanned, so avoid
-- repeatedly running broad queries against raw tables.

-- 1. Trip table row count, date range, and basic null checks.
SELECT
    COUNT(*) AS total_rows,
    MIN(DATE(tpep_pickup_datetime)) AS min_pickup_date,
    MAX(DATE(tpep_pickup_datetime)) AS max_pickup_date,
    COUNTIF(tpep_pickup_datetime IS NULL) AS null_pickup_datetimes,
    COUNTIF(tpep_dropoff_datetime IS NULL) AS null_dropoff_datetimes,
    COUNTIF(PULocationID IS NULL) AS null_pickup_location_ids,
    COUNTIF(DOLocationID IS NULL) AS null_dropoff_location_ids
FROM `nyc-taxi-project-502819.nyc_taxi_ops.raw_taxi_trips`;

-- 2. Trip month distribution.
SELECT
    FORMAT_DATE('%Y-%m', DATE(tpep_pickup_datetime)) AS pickup_month,
    COUNT(*) AS trips
FROM `nyc-taxi-project-502819.nyc_taxi_ops.raw_taxi_trips`
GROUP BY pickup_month
ORDER BY pickup_month;

-- 3. Obvious raw trip quality flags.
SELECT
    COUNT(*) AS total_rows,
    COUNTIF(trip_distance <= 0) AS non_positive_distance_rows,
    COUNTIF(total_amount <= 0) AS non_positive_total_amount_rows,
    COUNTIF(tpep_dropoff_datetime <= tpep_pickup_datetime) AS non_positive_duration_rows
FROM `nyc-taxi-project-502819.nyc_taxi_ops.raw_taxi_trips`;

-- 4. Zone lookup row count and distinct location IDs.
SELECT
    COUNT(*) AS zone_rows,
    COUNT(DISTINCT LocationID) AS distinct_location_ids,
    COUNTIF(LocationID IS NULL) AS null_location_ids,
    COUNTIF(Borough IS NULL) AS null_boroughs,
    COUNTIF(Zone IS NULL) AS null_zones
FROM `nyc-taxi-project-502819.nyc_taxi_ops.raw_zone_lookup`;

