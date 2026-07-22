-- Create the taxi zone dimension table.
--
-- One row = one taxi zone.

CREATE OR REPLACE TABLE `nyc-taxi-project-502819.nyc_taxi_ops.dim_zone`
CLUSTER BY location_id
AS
SELECT
    location_id,
    borough,
    zone_name,
    service_zone
FROM `nyc-taxi-project-502819.nyc_taxi_ops.stg_zones`;

