resource "azurerm_user_assigned_identity" "sb_producer" {
  name                = "if-${local.base_name}-sb-producer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_user_assigned_identity" "sb_consumer" {
  name                = "if-${local.base_name}-sb-consumer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
