data "template_file" "helmvalue-airflow" {
  template = file("airflow-values.yaml")
}

resource "helm_release" "aiflow" {
  name       = "airflow"
  repository = "https://mrmuggymuggy.github.io/helm-charts/"
  chart      = "airflow"
  namespace  = "default"
}