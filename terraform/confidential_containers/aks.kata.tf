resource "azapi_resource" "kata_node_pool" {
  type      = "Microsoft.ContainerService/managedClusters/agentPools@2022-09-01"
  name      = "kata"
  parent_id = azurerm_kubernetes_cluster.main.id

  body = jsonencode({
    properties = {
      vmSize            = "Standard_D2ads_v5"
      count             = 1
      osSKU             = "AzureLinux"
      osDiskType        = "Ephemeral"
      osDiskSizeGB      = 64
      workloadRuntime   = "KataMshvVmIsolation"
    }
  })
}