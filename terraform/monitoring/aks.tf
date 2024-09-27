resource "azurerm_kubernetes_cluster" "main" {
  name                 = "aks-${local.base_name}"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  dns_prefix           = "dns-${local.base_name}"
  azure_policy_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B8as_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  
  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings,
    ]
  }
}
