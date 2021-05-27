data "template_file" "helmvalue-traefik" {
  template = file("traefik-chart-values.yaml.tpl")
}

resource "helm_release" "ingress-controller" {
  name       = "traefik-ingress-controller"
  version    = "1.87.2"
  repository = "https://charts.helm.sh/stable"
  chart      = "traefik"
  namespace  = "kube-system"
  values = [
    data.template_file.helmvalue-traefik.rendered,
  ]
}