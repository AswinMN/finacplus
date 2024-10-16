# Outputs
output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke_cluster.name
}

output "gke_endpoint" {
  description = "The endpoint for GKE master"
  value       = google_container_cluster.gke_cluster.endpoint
}

output "gke_master_version" {
  description = "The Kubernetes master version"
  value       = google_container_cluster.gke_cluster.master_version
}

output "gke_node_pool_name" {
  description = "The name of the default node pool"
  value       = google_container_cluster.gke_cluster.node_pool[0].name
}

output "gke_network" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "gke_subnetwork" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}