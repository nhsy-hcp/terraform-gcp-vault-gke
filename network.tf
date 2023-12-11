locals {
  gke_subnet_name = "snet-gke"
}

module "network" {
  source = "./modules/network"

  network_name    = format("%s-%s", "vpc", module.common.unique_id)
  project         = var.project
  region          = var.region
  router_name     = format("%s-%s", "cr-nat-router", module.common.unique_id)
  router_nat_name = format("%s-%s", "rn-nat-gateway", module.common.unique_id)
  subnets = {
    "${var.region}/${local.gke_subnet_name}" = {
      subnet_name               = local.gke_subnet_name
      subnet_ip                 = var.subnet_cidr
      subnet_region             = var.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
    #    {
    #      subnet_name           = local.proxy_subnet_name
    #      subnet_ip             = var.proxy_subnet_cidr
    #      subnet_region         = var.region
    #      subnet_private_access = "false"
    #      purpose               = "REGIONAL_MANAGED_PROXY"
    #      role                  = "ACTIVE"
    #    }
    #  ]
  }
}