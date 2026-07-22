-- Create the standardized taxi zone staging table.
--
-- This query keeps the raw lookup table unchanged and writes a new table:
-- nyc-taxi-project-502819.nyc_taxi_ops.stg_zones

CREATE OR REPLACE TABLE `nyc-taxi-project-502819.nyc_taxi_ops.stg_zones`
CLUSTER BY location_id
AS
SELECT
    LocationID AS location_id,
    Borough AS borough,
    Zone AS zone_name,
    service_zone
FROM `nyc-taxi-project-502819.nyc_taxi_ops.raw_zone_lookup`
WHERE LocationID IS NOT NULL
    AND Borough IS NOT NULL
    AND Zone IS NOT NULL;

