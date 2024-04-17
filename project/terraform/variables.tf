variable "credentials" {
  description = "GCP credentials"
  default     = "./keys/creds.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "Project"
  default     = "careful-muse-411920"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "europe-west10"
}

variable "zone" {
  description = "Zone"
  #Update the below to your desired zone
  default     = "europe-west10-a"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "metrics_project_dataset"
}

# the bucket is not being created for now
variable "gcs_bucket_name" {
  description = "GCS Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "zoomcamp-de-project-2024-metrics"
}

# variable "gcs_storage_class" {
#   description = "Bucket Storage Class"
#   default     = "STANDARD"
# }