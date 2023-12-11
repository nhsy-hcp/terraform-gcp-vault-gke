resource "google_container_cluster" "gke_autopilot" {
  name     = var.gke_cluster_name
  location = var.region

  enable_autopilot = true
  networking_mode  = "VPC_NATIVE"
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "172.16.0.32/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = local.management_ip
    }
  }

  network    = module.network.network_name
  subnetwork = module.network.subnets_names["${var.region}/${local.gke_subnet_name}"]

  depends_on = [module.network]
}
