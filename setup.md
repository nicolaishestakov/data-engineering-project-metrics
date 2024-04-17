# Setup

This is about how to setup and run the project

## Prerequisites

The project components run in Docker containers, you may deploy them locally or somewhere in the cloud. I tested it locally on Windows 11 (with WSL).

You will need Google Cloud resources:
    - Bucket
    - BigQuery


## Setup

1. Google Cloud access
    - Generate an access key to Google Cloud
    - Save the key into /project/terraform/keys/creds.json so Terraform can manage GCS resources
    - Save the key into /project/containers/spark/keys/gcp-spark-key.json, this one will be deployed to spark container, so it can stream data to the cloud.

2. Create Google Cloud resources
    - Create a project on Google Cloud (or choose an existing one)
    - In the /project/terraform/variables.tf file 
        * set the variable 'project' to the name of your created GC project. 
        * set the variable 'gcs_bucket_name' to some *globally unique* bucket name (the existing one might not work because used by me)
        * You may also setup the region, zone and location, if you like
    - You will need to install terraform and probably Google Cloud CLI
    - From the /project/terraform folder run 'terraform init'
    - Then (optionally) run 'terraform plan' to see what's going to be created
    - Then run 'terraform apply' and confirm the changes

3. Create Docker containers
    - From /project/containers folder run the 'build.sh' script
    - TODO

TODO:
Initial repo cloning
Retrieve initial commit history

TODO: running Spark stream .csv->cloud

Generating metrics .csv data:

Taking code snapshot on repo:
    Run 'python startup.py --commit 71c783092597a50ef14fcd354cc6959af9f63f4d --nopull'

Producing metrics data on metrics-calc:
    sh scripts/generate_metrics.sh 71c783092597a50ef14fcd354cc6959af9f63f4d

Spark will stream the newly created .csv to cloud.
