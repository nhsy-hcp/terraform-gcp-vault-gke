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
  gke_cluster_name = format("%s-%s", var.gke_cluster_name, module.common.unique_id)
  management_ip    = "${chomp(data.http.management_ip.response_body)}/32"
  vault_fqdn       = "vault.${var.project}.${var.domain_name_suffix}"
  vault_url        = "https://vault.${var.project}.${var.domain_name_suffix}"
}
