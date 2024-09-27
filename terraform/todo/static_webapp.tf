resource "azurerm_static_web_app" "main" {
  name                = local.base_name
  resource_group_name = azurerm_resource_group.main.name
  location            = "westeurope"
  sku_tier            = "Standard"
  sku_size            = "Standard"
}

resource "azurerm_static_web_app_function_app_registration" "main" {
  static_web_app_id = azurerm_static_web_app.main.id
  function_app_id   = azurerm_linux_function_app.todo.id
}