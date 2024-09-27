resource "azurerm_kubernetes_cluster" "main" {
  name                      = "aks-${local.base_name}"
  location                  = azurerm_resource_group.main.location
  resource_group_name       = azurerm_resource_group.main.name
  dns_prefix                = "aks-${local.base_name}"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2ads_v5"
    os_sku          = "AzureLinux"
    os_disk_type    = "Ephemeral"
    os_disk_size_gb = 64
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].upgrade_settings]
  }
}
