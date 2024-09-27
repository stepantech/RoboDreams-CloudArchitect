resource "helm_release" "secret_app" {
  name  = "secret-app"
  chart = "../../helm/secret_app"

  depends_on = [
    azurerm_kubernetes_cluster.main,
    azurerm_kubernetes_cluster_node_pool.kata,
    azapi_resource.confidential_node_pool
  ]
}
