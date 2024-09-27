resource "azurerm_user_assigned_identity" "app" {
  name                = "if-${local.base_name}-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
