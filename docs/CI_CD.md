# CI/CD

This document explains the GitHub Actions check I added for the project.

## What CI/CD Means Here

CI/CD means GitHub automatically checks the project when code is pushed.

For this project, the current workflow checks the code and dbt project structure. It does not deploy anything.

Current workflow:

```text
push to GitHub
  -> install Python dependencies
  -> check Python script syntax
  -> parse the dbt project
  -> list dbt models, tests, and sources
```

## Workflow File

The GitHub Actions workflow lives here:

```text
.github/workflows/ci.yml
```

It runs on:

```text
push to main
pull request to main
```

## What The Workflow Checks

| Step | Purpose |
| --- | --- |
| Check out repository | Gets the latest project files from GitHub |
| Set up Python | Creates a clean Python environment in GitHub Actions |
| Install dependencies | Installs packages from `requirements.txt` |
| Check Python syntax | Confirms ingestion scripts can be parsed by Python |
| Create CI dbt profile | Gives dbt enough connection settings to parse the project |
| Parse dbt project | Checks dbt model, source, test, and YAML structure |
| List dbt resources | Confirms dbt can discover models, tests, and sources |

## What This Does Not Do Yet

The current CI workflow does not run live BigQuery jobs.

It does not run:

```text
dbt run
dbt test
```

Reason:

Those commands need Google Cloud credentials inside GitHub Actions. For this public version, I kept the workflow credential-free and only validate the project structure.

## Possible Upgrade

A more advanced version could use GitHub Secrets for Google Cloud authentication.

Then CI/CD could run:

```text
dbt build
```

That would build models and run tests against BigQuery automatically.

Future automation could also include:

- monthly scheduled ingestion
- source freshness checks
- alerts if dbt tests fail
- dashboard refresh workflow

## How I Explain It

If someone asks how CI/CD is handled:

```text
I added a GitHub Actions workflow that runs on pushes and pull requests. The workflow installs dependencies, checks the Python ingestion scripts, and validates the dbt project structure with dbt parse and dbt ls. I kept the first CI version credential-free for safety, and documented how it could be extended later with GitHub Secrets to run dbt build against BigQuery.
```
