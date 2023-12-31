resource "google_container_cluster" "autopilot" {
  name     = local.gke_cluster_name
  location = var.region

  enable_autopilot    = true
  networking_mode     = "VPC_NATIVE"
  deletion_protection = false

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
  subnetwork = module.network.subnet_name

  depends_on = [module.network]

  timeouts {
    delete = "30m"
  }
}
