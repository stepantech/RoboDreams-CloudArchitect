resource "azurerm_databricks_workspace" "main" {
  name                             = "dbw-${local.base_name}"
  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  sku                              = "premium"
  access_connector_id              = azurerm_databricks_access_connector.main.id
  default_storage_firewall_enabled = false
}

# resource "databricks_repo" "main" {
#   url = "https://github.com/tkubica12/cloud-arch-app-data.git"
# }