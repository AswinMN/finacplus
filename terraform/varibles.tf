#===============

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "gke-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "gke-subnet"
}

variable "subnet_cidr" {
  description = "The CIDR range of the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "machine_type" {
  description = "The type of machine to use for nodes"
  type        = string
  default     = "n1-standard-1"
}

variable "min_master_version" {
  description = "The minimum master version of Kubernetes"
  type        = string
  default     = "1.20"
}

variable "node_locations" {
  description = "The locations where the nodes will be created"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "min_node_count" {
  description = "The minimum number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "The maximum number of nodes in the node pool"
  type        = number
  default     = 3
}
