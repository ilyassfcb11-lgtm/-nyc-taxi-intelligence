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

