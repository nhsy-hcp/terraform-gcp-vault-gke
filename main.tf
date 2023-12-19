data "http" "management_ip" {
  url = "https://ipinfo.io/ip"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Status code invalid"
    }
  }
}

data "google_client_config" "current" {}

locals {
  gke_cluster_name = "${var.gke_cluster_name}-${module.common.unique_id}"
  gke_subnet_name  = "snet-gke-${module.common.unique_id}"
  management_ip    = "${chomp(data.http.management_ip.response_body)}/32"
  network_name     = "vpc-${module.common.unique_id}"
  vault_fqdn       = "${module.common.unique_id}.${var.project}.${var.domain_name_suffix}"
  vault_url        = "https://${local.vault_fqdn}"
}
