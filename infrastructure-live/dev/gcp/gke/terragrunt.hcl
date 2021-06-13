inputs = {
  project_id              = "gke-terragrunt-demo"
  cluster_name            = "gke-terragrunt-test"
  region                  = "europe-west1" 
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../infrastructure-modules/gcp//gke"
}
