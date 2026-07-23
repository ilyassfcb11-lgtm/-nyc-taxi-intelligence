{{ config(
    cluster_by=["location_id"]
) }}

SELECT
    LocationID AS location_id,
    Borough AS borough,
    Zone AS zone_name,
    service_zone
FROM {{ source('nyc_taxi_raw', 'raw_zone_lookup') }}
WHERE LocationID IS NOT NULL
    AND Borough IS NOT NULL
    AND Zone IS NOT NULL

