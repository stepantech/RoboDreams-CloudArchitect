data "azurerm_function_app_host_keys" "versionme" {
  name                = azurerm_linux_function_app.versionme.name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_api_management_backend" "versionme" {
  name                = "versionme"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "https://${azurerm_linux_function_app.versionme.default_hostname}/api"

  credentials {
    header = {
      "x-functions-key" = data.azurerm_function_app_host_keys.versionme.default_function_key
    }
  }
}


