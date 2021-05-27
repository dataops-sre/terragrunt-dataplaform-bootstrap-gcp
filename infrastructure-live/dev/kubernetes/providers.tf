variable "eks_cluster_id" {
  type        = string
  default     = "dummy"
  description = "describe your variable"
}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_id
}

provider "aws" {
  version = ">= 3.3.0"
  region  = "eu-west-2"
}

provider "kubernetes" {
  version                = "1.13.3"
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}


provider "helm" {
  version = "1.3.2"
  kubernetes {
    load_config_file       = "false"
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}