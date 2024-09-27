resource "azurerm_user_assigned_identity" "cassandra_client" {
  name                = "if-${local.base_name}-cassandra-client"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
