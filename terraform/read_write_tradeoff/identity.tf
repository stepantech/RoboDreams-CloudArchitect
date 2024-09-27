resource "azurerm_user_assigned_identity" "read_write_tradeoff" {
  name                = "if-${local.base_name}-read_write_tradeoff"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}