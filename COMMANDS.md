# Commands Cheat Sheet

This file keeps the common project commands in one place.

You do not need to memorize these commands. The goal is to understand what each one does and reuse them when needed.

## Move Into The Project Folder

```bash
cd "/Users/ilyass/Documents/Taxi project Codex."
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
git commit -m "Create Phase 0 project setup"
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

These commands open a browser so you can log in to your own Google account.

Codex does not see your password.

## Download MVP Source Data

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
cd "/Users/ilyass/Documents/Taxi project Codex./dbt_project"
source ../.venv/bin/activate
dbt run --profiles-dir .
```

This rebuilds the clean dbt tables in BigQuery:

```text
raw tables -> staging models -> core models -> mart models
```

## Test The dbt Pipeline

```bash
cd "/Users/ilyass/Documents/Taxi project Codex./dbt_project"
source ../.venv/bin/activate
dbt test --profiles-dir .
```

This checks saved data quality rules, such as not-null columns, unique IDs, fact-to-dimension relationships, and business rules for clean KPI reporting.

## Generate dbt Documentation

```bash
cd "/Users/ilyass/Documents/Taxi project Codex./dbt_project"
source ../.venv/bin/activate
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir . --port 8081 --no-browser
```

This creates and opens the local dbt documentation website.

After running the serve command, open:

```text
http://localhost:8081
```
