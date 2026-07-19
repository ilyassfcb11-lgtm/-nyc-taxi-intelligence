"""Download selected NYC TLC source files for the MVP.

This script only downloads official source files to the local `data/raw/`
folder. It does not load data into BigQuery and does not transform the data.
"""

from pathlib import Path

import requests
from tqdm import tqdm


RAW_DATA_DIR = Path("data/raw")

SOURCE_FILES = [
    {
        "filename": "yellow_tripdata_2026-04.parquet",
        "url": "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-04.parquet",
    },
    {
        "filename": "yellow_tripdata_2026-05.parquet",
        "url": "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-05.parquet",
    },
    {
        "filename": "taxi_zone_lookup.csv",
        "url": "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv",
    },
]


def download_file(url: str, destination: Path) -> None:
    """Download one URL to a local file path."""
    partial_destination = destination.with_suffix(destination.suffix + ".part")

    try:
        with requests.get(url, stream=True, timeout=60) as response:
            response.raise_for_status()
            total_size = int(response.headers.get("Content-Length", 0))

            with partial_destination.open("wb") as file:
                with tqdm(
                    total=total_size,
                    unit="B",
                    unit_scale=True,
                    desc=destination.name,
                ) as progress:
                    for chunk in response.iter_content(chunk_size=1024 * 1024):
                        if not chunk:
                            continue
                        file.write(chunk)
                        progress.update(len(chunk))

        partial_destination.replace(destination)
    except requests.RequestException as exc:
        if partial_destination.exists():
            partial_destination.unlink()
        raise RuntimeError(f"Failed to download {url}") from exc


def main() -> None:
    """Download all MVP source files."""
    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    for source_file in SOURCE_FILES:
        destination = RAW_DATA_DIR / source_file["filename"]

        if destination.exists():
            print(f"Skipping {destination.name}: already exists")
            continue

        print(f"Downloading {destination.name}")
        download_file(source_file["url"], destination)

    print("Download step complete.")


if __name__ == "__main__":
    main()
