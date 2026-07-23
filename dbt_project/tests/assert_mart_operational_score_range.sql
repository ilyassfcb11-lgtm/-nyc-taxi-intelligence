SELECT *
FROM {{ ref('mart_operational_kpis') }}
WHERE fleet_allocation_priority_score < 0
    OR fleet_allocation_priority_score > 100
