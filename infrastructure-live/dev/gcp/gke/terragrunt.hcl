inputs = {
  project_id              = "gke-terragrunt-demo"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../infrastructure-modules/gcp//gke"
}
