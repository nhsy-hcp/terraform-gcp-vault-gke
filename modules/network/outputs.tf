output "project" {
  description = "Project id"
  value       = google_compute_network.vpc.project
}

output "network" {
  description = "The created network"
  value       = google_compute_network.vpc
}

output "network_name" {
  description = "Name of VPC"
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "VPC network self link"
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets"
  value       = google_compute_subnetwork.subnetwork
}

output "subnets_names" {
  description = "The names of the subnets being created"
  #  value       = [for subnet in google_compute_subnetwork.subnetwork : subnet.name]
  value = { for k, v in google_compute_subnetwork.subnetwork : k => v.name }
}

output "subnets_ip_cidr_ranges" {
  description = "The IPs and CIDRs of the subnets being created"
  #  value       = [for subnet in google_compute_subnetwork.subnetwork : subnet.ip_cidr_range]
  value = { for k, v in google_compute_subnetwork.subnetwork : k => v.ip_cidr_range }
}

output "subnets_self_links" {
  description = "The self-links of subnets being created"
  #  value       = [for subnet in google_compute_subnetwork.subnetwork : subnet.self_link]
  value = { for k, v in google_compute_subnetwork.subnetwork : k => v.self_link }
}

output "subnets_regions" {
  description = "The region where the subnets will be created"
  #  value       = [for subnet in google_compute_subnetwork.subnetwork : subnet.region]
  value = { for k, v in google_compute_subnetwork.subnetwork : k => v.region }
}
