include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../aws/eks"]
}

terraform {
  source = "../../../../infrastructure-modules/kubernetes/mgmt"
}
