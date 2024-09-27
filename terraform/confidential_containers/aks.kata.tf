resource "azurerm_kubernetes_cluster_node_pool" "kata" {
  name                  = "kata"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D2ads_v5"
  node_count            = 1
  os_sku                = "AzureLinux"
  os_disk_type          = "Ephemeral"
  os_disk_size_gb       = 64
  workload_runtime      = "KataMshvVmIsolation"
}
