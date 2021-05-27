awsRegion: ${region}

rbac:
  create: true
  serviceAccountAnnotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::${aws_account_id}:role/cluster-autoscaler"

autoDiscovery:
  clusterName: ${cluster_name}
  enabled: true
