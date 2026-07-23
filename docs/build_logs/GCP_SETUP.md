# GCP Setup

This project uses Google Cloud Platform for BigQuery.

The project does not store Google credentials. Authentication happens through the user's browser or Google Cloud CLI session.

## Current Goal

Create or select one Google Cloud project for this portfolio project.

Status: complete.

Recommended project name:

```text
NYC Taxi Operations Intelligence
```

Recommended dataset name:

```text
nyc_taxi_ops
```

Active project ID:

```text
nyc-taxi-project-502819
```

Created BigQuery dataset:

```text
nyc-taxi-project-502819.nyc_taxi_ops
```

## Step 1: Open BigQuery

Go to:

```text
https://console.cloud.google.com/bigquery
```

If Google asks you to agree to terms, choose your country, accept the terms, and continue.

## Step 2: Create A Project

If you do not already have a project:

1. Click the project selector at the top of Google Cloud.
2. Click New Project.
3. Use the project name `NYC Taxi Operations Intelligence`.
4. Select `No organization` unless your school account requires an organization.
5. Click Create.

Google will create a unique project ID. Copy that project ID because we will use it in terminal commands.

Example project ID:

```text
nyc-taxi-ops-123456
```

Your actual project ID will probably be different.

## Step 3: Cost Control

For learning, use the BigQuery sandbox or free tier where possible.

According to Google Cloud documentation, BigQuery free usage includes 10 GiB of storage per month and 1 TiB of querying per month. The sandbox can be used without a billing account, but it has limitations such as table expiration and unsupported features.

For this project, we control cost by:

- starting with only two months of taxi data
- avoiding repeated full-table scans
- creating smaller summary tables for Tableau
- checking query size before running large queries
- avoiding unnecessary cloud services

## Step 4: Set The Project In Terminal

After you know your project ID, run:

```bash
gcloud config set project YOUR_PROJECT_ID
```

Replace `YOUR_PROJECT_ID` with the real project ID from Google Cloud.

Example:

```bash
gcloud config set project nyc-taxi-ops-123456
```

## Step 5: Confirm The Project

Run:

```bash
gcloud config list
```

You should see a `project` value under `[core]`.

## Step 6: BigQuery Dataset

After the project is selected, we will create a BigQuery dataset named:

```text
nyc_taxi_ops
```

This dataset will later contain raw tables, cleaned tables, and KPI marts.

Status: created.
