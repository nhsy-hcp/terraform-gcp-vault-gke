module "k8s" {
  source = "./modules/k8s"

  fqdn      = local.vault_fqdn
  unique_id = module.common.unique_id

  depends_on = [
    google_container_cluster.gke_autopilot
  ]
}
