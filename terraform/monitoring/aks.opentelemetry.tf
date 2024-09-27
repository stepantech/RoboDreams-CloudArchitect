resource "helm_release" "opentelemetry" {
  name             = "opentelemetry"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-demo"
  namespace        = "opentelemetry"
  create_namespace = true

  set {
    name  = "components.accountingService.resources.limits.memory"
    value = "100Mi"
  }

  set {
    name  = "components.flagd.resources.limits.memory"
    value = "100Mi"
  }
}

