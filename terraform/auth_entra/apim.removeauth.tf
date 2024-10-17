resource "azurerm_api_management_api" "removeauth" {
  name                = "removeauth"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "removeauth"
  protocols           = ["https"]
  path                = "removeauth"
}

resource "azurerm_api_management_api_operation" "removeauth" {
  operation_id        = "custom-api-removeauth-get"
  api_name            = azurerm_api_management_api.removeauth.name
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  display_name        = "Get"
  description         = "Get from custom API using removeauth"
  method              = "GET"
  url_template        = "/"
}

resource "azurerm_api_management_api_operation_policy" "removeauth" {
  api_name            = azurerm_api_management_api_operation.removeauth.api_name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.removeauth.operation_id

  xml_content = local.removeauth_policy
}

locals {
  removeauth_policy = <<EOF
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="https://${azurerm_container_app.auth_open_api.ingress[0].fqdn}" />
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
          <openid-config url="${var.AUTHORITY}/v2.0/.well-known/openid-configuration" />
          <audiences>
              <audience>${var.API_CLIENT_ID}</audience>
          </audiences>
          <issuers>
              <issuer>https://login.microsoftonline.com/${var.TENANT_ID}/v2.0</issuer>
          </issuers>
          <required-claims>
              <claim name="azp">
                  <value>${var.BACKGROUND_CLIENT_ID}</value>
              </claim>
          </required-claims>
      </validate-jwt>
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

resource "azurerm_api_management_product_api" "removeauth" {
  product_id          = azurerm_api_management_product.main.product_id
  api_name            = azurerm_api_management_api.removeauth.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
}
