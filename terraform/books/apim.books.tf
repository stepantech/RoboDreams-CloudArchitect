resource "azurerm_api_management_api" "books" {
  name                = "books"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Books"
  protocols           = ["https"]
}

data "azurerm_function_app_host_keys" "books" {
  name                = azurerm_linux_function_app.books.name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_api_management_backend" "books" {
  name                = "books"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "https://${azurerm_linux_function_app.books.default_hostname}/api"

  credentials {
    header = {
      "x-functions-key" = data.azurerm_function_app_host_keys.books.default_function_key
    }
  }
}


locals {
  books_policy = <<EOF
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="books" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
EOF
}
