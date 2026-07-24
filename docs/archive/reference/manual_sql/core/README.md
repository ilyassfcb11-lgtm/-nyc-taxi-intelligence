# Core Model SQL

Core model tables sit between staging tables and KPI marts.

```text
staging tables
        |
        v
fact and dimension tables
        |
        v
KPI mart tables
```

## Tables

| Table | Purpose |
| --- | --- |
| `fact_trips` | One cleaned business trip per row, with numeric trip measures |
| `dim_zone` | One taxi zone per row, with borough and zone attributes |
| `dim_date` | One calendar date per row, with reusable date attributes |

## Why This Layer Exists

Staging tables clean and standardize raw data.

Core model tables organize the data into business-friendly analytical structures:

- facts contain measurable events
- dimensions contain descriptive context

This makes KPI queries easier to write and easier to explain.

