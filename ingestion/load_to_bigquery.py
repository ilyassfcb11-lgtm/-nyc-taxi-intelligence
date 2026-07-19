"""Load downloaded NYC TLC source files into BigQuery raw tables.

This script loads local files from `data/raw/` into the BigQuery dataset for
this project. It does not clean, transform, or calculate KPIs.
"""

import os
from pathlib import Path

from google.cloud import bigquery


PROJECT_ID = os.getenv("GCP_PROJECT_ID", "nyc-taxi-project-502819")
DATASET_ID = os.getenv("BQ_DATASET_ID", "nyc_taxi_ops")
RAW_DATA_DIR = Path("data/raw")

TRIP_FILES = [
    RAW_DATA_DIR / "yellow_tripdata_2026-04.parquet",
    RAW_DATA_DIR / "yellow_tripdata_2026-05.parquet",
]
ZONE_LOOKUP_FILE = RAW_DATA_DIR / "taxi_zone_lookup.csv"

RAW_TRIPS_TABLE = "raw_taxi_trips"
RAW_ZONES_TABLE = "raw_zone_lookup"


def table_id(table_name: str) -> str:
    """Return a full BigQuery table ID."""
    return f"{PROJECT_ID}.{DATASET_ID}.{table_name}"


def require_files(paths: list[Path]) -> None:
    """Stop early if any expected source file is missing."""
    missing_files = [str(path) for path in paths if not path.exists()]

    if missing_files:
        missing_list = "\n".join(f"- {path}" for path in missing_files)
        raise FileNotFoundError(
            "Missing required source files. Run ingestion/download_data.py first:\n"
            f"{missing_list}"
        )


def load_trip_files(client: bigquery.Client) -> None:
    """Load Yellow Taxi Parquet files into the raw trips table."""
    destination_table = table_id(RAW_TRIPS_TABLE)

    for index, trip_file in enumerate(TRIP_FILES):
        write_disposition = (
            bigquery.WriteDisposition.WRITE_TRUNCATE
            if index == 0
            else bigquery.WriteDisposition.WRITE_APPEND
        )

        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
            write_disposition=write_disposition,
        )

        print(f"Loading {trip_file.name} into {destination_table}")
        with trip_file.open("rb") as file:
            load_job = client.load_table_from_file(
                file,
                destination_table,
                job_config=job_config,
            )

        load_job.result()
        print(f"Loaded {trip_file.name}")


def load_zone_lookup(client: bigquery.Client) -> None:
    """Load Taxi Zone Lookup CSV into the raw zone lookup table."""
    destination_table = table_id(RAW_ZONES_TABLE)

    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    )

    print(f"Loading {ZONE_LOOKUP_FILE.name} into {destination_table}")
    with ZONE_LOOKUP_FILE.open("rb") as file:
        load_job = client.load_table_from_file(
            file,
            destination_table,
            job_config=job_config,
        )

    load_job.result()
    print(f"Loaded {ZONE_LOOKUP_FILE.name}")


def print_table_summary(client: bigquery.Client, table_name: str) -> None:
    """Print row count and storage size for one loaded table."""
    table = client.get_table(table_id(table_name))
    size_mb = table.num_bytes / 1024 / 1024
    print(f"{table_name}: {table.num_rows:,} rows, {size_mb:.2f} MB")


def main() -> None:
    """Load all local MVP source files into BigQuery raw tables."""
    require_files([*TRIP_FILES, ZONE_LOOKUP_FILE])

    client = bigquery.Client(project=PROJECT_ID)

    load_trip_files(client)
    load_zone_lookup(client)

    print("Raw BigQuery load complete.")
    print_table_summary(client, RAW_TRIPS_TABLE)
    print_table_summary(client, RAW_ZONES_TABLE)


if __name__ == "__main__":
    main()

