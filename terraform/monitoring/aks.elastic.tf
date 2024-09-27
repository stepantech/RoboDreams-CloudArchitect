resource "helm_release" "elastic" {
  name      = "elastic"
  chart     = "${path.module}/helm/elastic"
}


resource "helm_release" "elastic_demo" {
  name      = "elastic-demo"
  chart     = "${path.module}/helm/elastic_demo"

  depends_on = [ helm_release.elastic ]
}

resource "helm_release" "kube_state_metrics" {
  name             = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-state-metrics"
  namespace        = "kube-system"
  create_namespace = true
}