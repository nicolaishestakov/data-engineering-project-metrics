terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.15.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
  zone        = var.zone
}


resource "google_storage_bucket" "auto-expire" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "metrics_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}

resource "google_bigquery_table" "metrics_table" {
  dataset_id = google_bigquery_dataset.metrics_dataset.dataset_id
  table_id   = "metrics"

# commit: git commit hash
# timestamp: time of the commit from git, belongs to the commit, denormalized for partitioning
# filepath: source file path
# area: area of the code (e.g., function)
# std_code_lines_code: line count metric for the area in file
# std_code_complexity_cyclomatic: complexity metric for the area in file

  schema = <<EOF
[
  {"name": "commit", "type": "STRING"},
  {"name": "timestamp", "type": "TIMESTAMP"},
  {"name": "filepath", "type": "STRING"},
  {"name": "area", "type": "STRING"},
  {"name": "std_code_lines_code", "type": "FLOAT"},
  {"name": "std_code_complexity_cyclomatic", "type": "FLOAT"}
]
EOF

  depends_on = [google_bigquery_dataset.metrics_dataset]
}

resource "google_bigquery_table" "external_table" {
  dataset_id = google_bigquery_dataset.metrics_dataset.dataset_id
  table_id   = "metrics-parquet-view"
  
  schema = <<EOF
[
  {"name": "commit", "type": "STRING"},
  {"name": "filepath", "type": "STRING"},
  {"name": "area", "type": "STRING"},
  {"name": "std_code_lines_code", "type": "FLOAT"},
  {"name": "std_code_complexity_cyclomatic", "type": "FLOAT"}
]
EOF

  depends_on = [google_bigquery_dataset.metrics_dataset]
  external_data_configuration {
    autodetect    = false
    source_format = "PARQUET"
    source_uris   = ["gs://${var.gcs_bucket_name}/metrics_data/*.parquet"]
  }
}