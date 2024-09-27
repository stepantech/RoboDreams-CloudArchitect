resource "azurerm_user_assigned_identity" "json_producer" {
  name                = "if-${local.base_name}-json-producer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
