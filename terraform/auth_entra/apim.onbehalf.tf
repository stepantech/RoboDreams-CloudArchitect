# resource "azurerm_api_management_authorization_server" "onbehalf" {
#   name                         = "auth-entra-api"
#   api_management_name          = azurerm_api_management.main.name
#   resource_group_name          = azurerm_resource_group.main.name
#   display_name                 = "auth-entra-api"
#   authorization_endpoint       = var.AUTHORITY
#   client_id                    = var.APIM_CLIENT_ID
#   client_secret                = var.APIM_CLIENT_SECRET
#   client_registration_endpoint = "https://login.microsoftonline.com/${var.TENANT_ID}/oauth2/v2.0/token"

#   grant_types = [
#     "clientCredentials",
#   ]
#   authorization_methods = [
#     "GET",
#   ]
# }


resource "azurerm_api_management_api" "onbehalf" {
  name                = "onbehalf"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "onbehalf"
  protocols           = ["https"]
  path                = "onbehalf"
}

resource "azurerm_api_management_api_operation" "onbehalf" {
  operation_id        = "custom-api-onbehalf-get"
  api_name            = azurerm_api_management_api.onbehalf.name
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  display_name        = "Get"
  description         = "Get from custom API using onbehalf"
  method              = "GET"
  url_template        = "/"
}

resource "azurerm_api_management_api_operation_policy" "onbehalf" {
  api_name            = azurerm_api_management_api_operation.onbehalf.api_name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.onbehalf.operation_id

  xml_content = local.onbehalf_policy

}

locals {
  onbehalf_policy = <<EOF
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="https://${azurerm_container_app.auth_entra_api.ingress[0].fqdn}" />
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

resource "azurerm_api_management_product_api" "onbehalf" {
  product_id          = azurerm_api_management_product.main.product_id
  api_name            = azurerm_api_management_api.onbehalf.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
}
