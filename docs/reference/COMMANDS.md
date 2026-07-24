# Commands Cheat Sheet

This file keeps the common project commands in one place.

I use this as a quick reference so I do not have to remember every command from memory.

## Move Into The Project Folder

```bash
cd path/to/nyc-taxi-intelligence
```

This tells the terminal to work inside this project folder.

## Turn On The Python Environment

```bash
source .venv/bin/activate
```

This activates the Python environment for this project.

When it is active, Python packages install inside this project environment instead of being mixed with the rest of your Mac.

## Install Python Packages

```bash
pip install -r requirements.txt
```

This installs the Python libraries listed in `requirements.txt`.

## Check Git Status

```bash
git status
```

This shows which files are new, changed, or ready to commit.

## Save A Git Checkpoint

```bash
git add .
git commit -m "Save project setup"
```

This saves a checkpoint in the project history.

## Check Google Cloud CLI

```bash
gcloud --version
```

This checks whether the Google Cloud command line tool is available.

## Log In To Google Cloud

```bash
gcloud auth login
gcloud auth application-default login
```

These commands open a browser for Google Cloud login.

Credentials are handled by Google Cloud in your browser or local CLI session.

## Download Source Data

```bash
source .venv/bin/activate
python ingestion/download_data.py
```

This downloads the selected official NYC TLC files into `data/raw/`.

The downloaded data files are ignored by Git because they are large source files.

## Load Raw Data To BigQuery

```bash
source .venv/bin/activate
python ingestion/load_to_bigquery.py
```

This loads the local files from `data/raw/` into the BigQuery dataset:

```text
nyc-taxi-project-502819.nyc_taxi_ops
```

It creates or replaces these raw tables:

```text
raw_taxi_trips
raw_zone_lookup
```

## Run The dbt Pipeline

```bash
cd dbt_project
source ../.venv/bin/activate
dbt run --profiles-dir .
```

This rebuilds the clean dbt tables in BigQuery:

```text
raw tables -> staging models -> core models -> mart models
```

## Test The dbt Pipeline

```bash
cd dbt_project
source ../.venv/bin/activate
dbt test --profiles-dir .
```

This checks saved data quality rules, such as not-null columns, unique IDs, fact-to-dimension relationships, and business rules for KPI reporting.

## Generate dbt Documentation

```bash
cd dbt_project
source ../.venv/bin/activate
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir . --port 8081 --no-browser
```

This creates and opens the local dbt documentation website.

After running the serve command, open:

```text
http://localhost:8081
```

## CI/CD Check

The project has a GitHub Actions workflow in:

```text
.github/workflows/ci.yml
```

This usually does not need to be run manually.

It runs automatically when code is pushed to GitHub.
