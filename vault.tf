module "k8s" {
  source = "./modules/k8s"

  create                       = var.create_k8s
  cloud_armour_whitelist_cidrs = concat([local.management_ip], var.vault_client_cidrs)
  fqdn                         = local.vault_fqdn
  unique_id                    = module.common.unique_id
  vault_chart_version          = var.vault_chart_version
  vault_license                = var.vault_license
  vault_repository             = var.vault_repository
  vault_version_tag            = var.vault_version_tag

  depends_on = [
    google_container_cluster.gke_autopilot
  ]
}
