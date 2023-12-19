variable "project" {
  description = "Project ID to deploy into"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  default     = "europe-west1"
  type        = string
}

variable "subnet_cidr" {
  type    = string
  default = "10.64.0.0/16"
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


variable "vault_chart_version" {
  type    = string
  default = "0.27.0"
}

variable "vault_repository" {
  type    = string
  default = "hashicorp/vault"
}

variable "vault_version_tag" {
  type    = string
  default = "1.15.4"
}

variable "vault_license" {
  type    = string
  default = null
}

variable "gke_cluster_name" {
  type    = string
  default = "vault-autopilot"
}

variable "create_k8s" {
  type    = bool
  default = true
}

variable "vault_client_cidrs" {
  type    = list(string)
  default = []
}

variable "dns_managed_zone_name" {
  type = string
}