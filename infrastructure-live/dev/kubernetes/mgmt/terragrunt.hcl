include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name            = "gke-terragrunt-test"
  project_id              = "gke-terragrunt-demo"
  region                  = "europe-west1" 
}

dependencies {
  paths = ["../../gcp/gke"]
}

terraform {
  source = "../../../../infrastructure-modules/kubernetes//mgmt"
}
