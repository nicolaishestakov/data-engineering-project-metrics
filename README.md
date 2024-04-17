# metrics
de-zoomcamp 2024 course project.

# Overview

This project is about getting code quality metrics from a given codebase, collect and process them in a cloud, and visualize. This project is not using an external dataset, but produces the data from the target repository.
 - Target repository is cloned in a container for analysis,
 - code metrics are calculated for each commit,
 - code metrics data are uploaded into cloud,
 - in the cloud the data are processed and visualized

# Technology stack

Docker

git and GitPython to automate working with target repository
  - getting commit history and info
  - checking out source file versions

metrix++ https://metrixplusplus.github.io/metrixplusplus/
  - calculate code quality metrics (lines of code, cyclomatic complexity)
  - export metrics data to .csv

Spark
  - streaming .csv metrics data to GCS Bucket in .parquet format

Terraform
  - manage Google Cloud resources

Google Cloud
  - Load source data into GCS Bucket
  - (TODO) Transfer data to BigTable for analysis
  - (TODO) Visualization

Kafka
  - (TODO) Sending commands to the components of the system
