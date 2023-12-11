variable "project" {
  description = "Project ID to deploy into"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  default     = "europe-west1"
  type        = string

  validation {
    condition     = can(regex("(europe-west1|europe-west2|us-central1)", var.region))
    error_message = "The region must be one of: europe-west1, europe-west2, us-central1."
  }
}

variable "subnet_cidr" {
  type    = string
  default = "10.64.0.0/16"
}

variable "proxy_subnet_cidr" {
  type    = string
  default = "10.65.0.0/16"
}


variable "google_apis" {
  type = set(string)
  default = [
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "iap.googleapis.com",
  ]
}

variable "domain_name_suffix" {
  type    = string
  default = "gcp.sbx.hashicorpdemo.com"
}

variable "mig_target_size" {
  type    = number
  default = 3
}

variable "vault_license" {
  type    = string
  default = ""
}

variable "vault_version" {
  type    = string
  default = "1.15.4"
}

variable "gke_cluster_name" {
  type    = string
  default = "gke-autopilot"
}