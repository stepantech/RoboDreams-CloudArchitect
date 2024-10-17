resource "helm_release" "secret_app" {
  name  = "secret-app"
  chart = "../../helm/secret_app"

  depends_on = [
    azurerm_kubernetes_cluster.main,
    azapi_resource.kata_node_pool,
    azapi_resource.confidential_node_pool
  ]
}
