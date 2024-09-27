resource "helm_release" "prometheus" {
  name             = "prometheus-operator"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  create_namespace = true

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}

resource "helm_release" "prometheus_demo" {
  name      = "prometheus-demo"
  chart     = "${path.module}/helm/prometheus_demo"
  namespace = "default"

  set {
    name  = "deploy-timestamp"
    value = timestamp()
  }

  depends_on = [ helm_release.prometheus ]
}
