variable "cluster_name" {
  type        = string
  default     = "gke-on-vpc-cluster"
  description = "describe your variable"
}

variable "project_id" {
  type        = string
  default     = "demo"
  description = "describe your variable"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west1"
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_container_cluster" "gke_cluster" {
  name = var.cluster_name
  project = var.project_id
  location = var.region
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  version = "1.3.2"
  kubernetes {
    load_config_file       = "false"
    host                   = "https://${data.google_container_cluster.gke_cluster.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}