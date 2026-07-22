-- Create the date dimension table for the MVP window.
--
-- One row = one calendar date.

CREATE OR REPLACE TABLE `nyc-taxi-project-502819.nyc_taxi_ops.dim_date`
AS
SELECT
    calendar_date,
    EXTRACT(YEAR FROM calendar_date) AS year,
    EXTRACT(MONTH FROM calendar_date) AS month,
    FORMAT_DATE('%Y-%m', calendar_date) AS year_month,
    EXTRACT(DAY FROM calendar_date) AS day_of_month,
    FORMAT_DATE('%A', calendar_date) AS day_name,
    EXTRACT(DAYOFWEEK FROM calendar_date) AS day_of_week_number,
    EXTRACT(DAYOFWEEK FROM calendar_date) IN (1, 7) AS is_weekend
FROM UNNEST(GENERATE_DATE_ARRAY(DATE '2026-04-01', DATE '2026-05-31')) AS calendar_date;

