generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("providers.tf"))
}

remote_state {
  backend = "gcs"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    project  = "gke-terragrunt-demo"
    location = "eu"
    bucket   = "gke-terragrunt-demo-remote-states"
    prefix   = "${path_relative_to_include()}/terraform.tfstate"

    gcs_bucket_labels = {
      owner = "terragrunt_test"
      name  = "terraform_state_storage"
    }
  }
}

inputs = {
  ### PROVIDER PARAMETERS
  eks_cluster_id       = "test-eks-irsa"
}
