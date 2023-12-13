###
# Create vpc network
###

resource "google_compute_network" "vpc" {
  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  project                         = var.project
  description                     = var.description
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
}

###
# Create subnets
###
resource "google_compute_subnetwork" "subnetwork" {
  for_each                 = var.subnets
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")

  dynamic "log_config" {
    for_each = coalesce(lookup(each.value, "subnet_flow_logs", null), false) ? [{
      aggregation_interval = each.value.subnet_flow_logs_interval
      flow_sampling        = each.value.subnet_flow_logs_sampling
      metadata             = each.value.subnet_flow_logs_metadata
      filter_expr          = each.value.subnet_flow_logs_filter
      metadata_fields      = each.value.subnet_flow_logs_metadata_fields
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? log_config.value.metadata_fields : null
    }
  }

  network     = google_compute_network.vpc.self_link
  project     = var.project
  description = lookup(each.value, "description", null)
  #  secondary_ip_range = [
  #    for i in range(
  #      length(
  #        contains(
  #        keys(var.secondary_ranges), each.value.subnet_name) == true
  #        ? var.secondary_ranges[each.value.subnet_name]
  #        : []
  #    )) :
  #    var.secondary_ranges[each.value.subnet_name][i]
  #  ]

  purpose = lookup(each.value, "purpose", null)
  role    = lookup(each.value, "role", null)

  lifecycle {
    ignore_changes = [
      secondary_ip_range # Ignore changes to secondary ranges for gke autopilot
    ]
  }
}

###
# Create cloud router and nat gateway
###
resource "google_compute_router" "router" {
  name    = var.router_name
  network = google_compute_network.vpc.self_link
  region  = var.region
  project = var.project
}

resource "google_compute_router_nat" "nat" {
  name                               = var.router_nat_name
  project                            = var.project
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}