variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset"
  type        = string
}

variable "table_id" {
  description = "The ID of the BigQuery table"
  type        = string
}

variable "schema" {
  description = "The schema for the BigQuery table in JSON format"
  type        = string
}

variable "labels" {
  description = "Optional labels for the BigQuery dataset"
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the table"
  type        = bool
  default     = false
}
