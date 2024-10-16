# Define the provider for Google Cloud
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a VPC for GKE cluster
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

# Create subnetwork
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
  ip_cidr_range = var.subnet_cidr
}

# Create GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
  location           = var.region
  initial_node_count = 1
  min_master_version = var.min_master_version

  # Enable Private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.0.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet.secondary_ip_range_name
    services_secondary_range_name = google_compute_subnetwork.subnet.secondary_ip_range_name
  }

  # Specify the network settings
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Define node pools
  node_pool {
    name = "default-node-pool"

    node_config {
      machine_type = var.machine_type
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

      labels = {
        "env" = "dev"
      }

      tags = ["gke-node"]
    }
    node_locations = var.node_locations
    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }

    management {
      auto_upgrade = true
      auto_repair  = true
    }
  }
}

# Create firewall rule to allow internal communication
resource "google_compute_firewall" "gke_firewall" {
  name    = "gke-firewall-rule"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"]
  target_tags   = ["gke-node"]
}

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