output "project" {
  value = var.project
}
output "region" {
  value = var.region
}

output "gke_cluster_name" {
  value = local.gke_cluster_name
}

output "vault_fqdn" {
  value = local.vault_fqdn
}

output "vault_url" {
  value = local.vault_url
}

output "vault_ip_address" {
  value = module.k8s.lb_ip_address
}