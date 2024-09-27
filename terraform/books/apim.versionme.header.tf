// APIs with versions
resource "azurerm_api_management_api" "versionme_header_v1" {
  name                = "versionme-header-v1"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  version             = "v1"
  version_set_id      = azurerm_api_management_api_version_set.versionme_header.id
  revision            = "1"
  display_name        = "VersionMe v1 via header"
  protocols           = ["https"]
  path                = "versionme-header"
}

# resource "azurerm_api_management_api" "versionme_header_v1_rev2" {
#   name                 = "versionme-header-v1"
#   resource_group_name  = azurerm_resource_group.main.name
#   api_management_name  = azurerm_api_management.main.name
#   version              = "v1"
#   version_set_id       = azurerm_api_management_api_version_set.versionme_header.id
#   revision             = "2"
#   revision_description = "Next revision of v1 API"
#   display_name         = "VersionMe v1 via header"
#   protocols            = ["https"]
#   path                 = "versionme-header"
# }

resource "azurerm_api_management_api" "versionme_header_v2" {
  name                = "versionme-header-v2"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  version             = "v2"
  version_set_id      = azurerm_api_management_api_version_set.versionme_header.id
  revision            = "1"
  display_name        = "VersionMe v2 via header"
  protocols           = ["https"]
  path                = "versionme-header"
}

resource "azurerm_api_management_api_version_set" "versionme_header" {
  name                = "versionme-header"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  display_name        = "VersionMe using header"
  versioning_scheme   = "Header"
  version_header_name = "x-api-version"
}

// Policies
locals {
  versionme_header_policy_v1      = <<EOF
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="versionme" />
        <rewrite-uri template="/versionme1" />
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
#   versionme_header_policy_v1_rev2 = <<EOF
# <policies>
#     <inbound>
#         <base />
#         <set-backend-service backend-id="versionme" />
#         <rewrite-uri template="/versionme1next" />
#     </inbound>
#     <backend>
#         <base />
#     </backend>
#     <outbound>
#         <base />
#     </outbound>
#     <on-error>
#         <base />
#     </on-error>
# </policies>
# EOF
  versionme_header_policy_v2      = <<EOF
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="versionme" />
        <rewrite-uri template="/versionme2" />
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

// Operations
resource "azurerm_api_management_api_operation" "versionme_header_v1" {
  operation_id        = "readVersion"
  api_name            = regex("([^/]+$)", azurerm_api_management_api.versionme_header_v1.id)[0]
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "readVersion"
  method              = "GET"
  url_template        = "/versions"
  description         = <<EOF
    Demo call to retrieve service version.
EOF


  request {
    description = <<EOF
Simple GET request to retrieve the service version.
EOF
  }

  response {
    status_code = 200
    description = "Version information."

    representation {
      content_type = "application/json"

      example {
        name  = "version"
        value = <<EOF
{
  "version": "1.0.0"
}
EOF
      }
    }
  }
}

# resource "azurerm_api_management_api_operation" "versionme_header_v1_rev2" {
#   operation_id        = "readVersion"
#   api_name            = regex("([^/]+$)", azurerm_api_management_api.versionme_header_v1_rev2.id)[0]
#   api_management_name = azurerm_api_management.main.name
#   resource_group_name = azurerm_resource_group.main.name
#   display_name        = "readVersion"
#   method              = "GET"
#   url_template        = "/versions"
#   description         = <<EOF
#     Demo call to retrieve service version.
# EOF


#   request {
#     description = <<EOF
# Simple GET request to retrieve the service version.
# EOF
#   }

#   response {
#     status_code = 200
#     description = "Version information."

#     representation {
#       content_type = "application/json"

#       example {
#         name  = "version"
#         value = <<EOF
# {
#   "version": "1.0.0"
# }
# EOF
#       }
#     }
#   }
# }

resource "azurerm_api_management_api_operation" "versionme_header_v2" {
  operation_id        = "readVersion"
  api_name            = regex("([^/]+$)", azurerm_api_management_api.versionme_header_v2.id)[0]
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "readVersion"
  method              = "GET"
  url_template        = "/versions"
  description         = <<EOF
    Demo call to retrieve service version.
EOF


  request {
    description = <<EOF
Simple GET request to retrieve the service version.
EOF
  }

  response {
    status_code = 200
    description = "Version information."

    representation {
      content_type = "application/json"

      example {
        name  = "version"
        value = <<EOF
{
  "version": "1.0.0"
}
EOF
      }
    }
  }
}

// Policy assignments
resource "azurerm_api_management_api_operation_policy" "versionme_header_v1" {
  api_name            = regex("([^/]+$)", azurerm_api_management_api.versionme_header_v1.id)[0]
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.versionme_header_v1.operation_id
  xml_content         = local.versionme_header_policy_v1

  depends_on = [azurerm_api_management_backend.versionme]
}

# resource "azurerm_api_management_api_operation_policy" "versionme_header_v1_rev2" {
#   api_name            = regex("([^/]+$)", azurerm_api_management_api.versionme_header_v1_rev2.id)[0]
#   api_management_name = azurerm_api_management.main.name
#   resource_group_name = azurerm_resource_group.main.name
#   operation_id        = azurerm_api_management_api_operation.versionme_header_v1_rev2.operation_id
#   xml_content         = local.versionme_header_policy_v1_rev2

#   depends_on = [azurerm_api_management_backend.versionme]
# }

resource "azurerm_api_management_api_operation_policy" "versionme_header_v2" {
  api_name            = regex("([^/]+$)", azurerm_api_management_api.versionme_header_v2.id)[0]
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  operation_id        = azurerm_api_management_api_operation.versionme_header_v2.operation_id
  xml_content         = local.versionme_header_policy_v2

  depends_on = [azurerm_api_management_backend.versionme]
}