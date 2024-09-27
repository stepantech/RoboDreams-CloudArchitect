resource "azapi_resource" "confidential_node_pool" {
  type      = "Microsoft.ContainerService/managedClusters/agentPools@2022-09-01"
  name      = "confidential"
  parent_id = azurerm_kubernetes_cluster.main.id

  body = jsonencode({
    properties = {
      vmSize            = "Standard_DC4ads_cc_v5"
      count             = 1
      osSKU             = "AzureLinux"
      osDiskType        = "Ephemeral"
      osDiskSizeGB      = 128
      workloadRuntime   = "KataCcIsolation"
    }
  })
}