resource "azurerm_api_management_api" "passthrough" {
  name                = "passthrough"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "passthrough"
  protocols           = ["https"]
  path                = "passthrough"
}

resource "azurerm_api_management_api_operation" "passthrough" {
  operation_id        = "custom-api-get"
  api_name            = azurerm_api_management_api.passthrough.name
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  display_name        = "Get"
  description         = "Get from custom API using passthrough"
  method              = "GET"
  url_template        = "/"
}

resource "azurerm_api_management_api_operation_policy" "passthrough" {
  api_name            = azurerm_api_management_api_operation.passthrough.api_name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.passthrough.operation_id

  xml_content = local.passthrough_policy
}

locals {
  passthrough_policy = <<EOF
<policies>
    <inbound>
      <base />
      <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
        <openid-config url="${var.AUTHORITY}/v2.0/.well-known/openid-configuration" />
        <audiences>
            <audience>${var.API_CLIENT_ID}</audience>
        </audiences>
        <issuers>
            <issuer>https://login.microsoftonline.com/${var.TENANT_ID}/v2.0</issuer>
        </issuers>
        <required-claims>
            <claim name="scp">
                <value>Stuff.Read</value>
            </claim>
        </required-claims>
      </validate-jwt>
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

resource "azurerm_api_management_product_api" "passthrough" {
  product_id            = azurerm_api_management_product.main.product_id
  api_name              = azurerm_api_management_api.passthrough.name
  api_management_name   = azurerm_api_management.main.name
  resource_group_name   = azurerm_resource_group.main.name
}