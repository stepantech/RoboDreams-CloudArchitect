resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${local.base_name}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

# resource "azapi_resource" "capp_env" {
#   type = "Microsoft.App/managedEnvironments@2023-11-02-preview"
#   name = "cae-${local.base_name}"
#   location                   = azurerm_resource_group.main.location
#   parent_id = azurerm_resource_group.main.id

#   identity {
#     type = "SystemAssigned"
#   }

#   body = jsonencode({
#     properties = {
#       # appInsightsConfiguration = {
#       #   connectionString = "string"
#       # }
#       # appLogsConfiguration = {
#       #   destination = "string"
#       #   logAnalyticsConfiguration = {
#       #     customerId = "string"
#       #     dynamicJsonColumns = bool
#       #     sharedKey = "string"
#       #   }
#       # }
#       # customDomainConfiguration = {
#       #   certificateKeyVaultProperties = {
#       #     identity = "string"
#       #     keyVaultUrl = "string"
#       #   }
#       #   certificatePassword = "string"
#       #   dnsSuffix = "string"
#       # }
#       # daprAIConnectionString = "string"
#       # daprAIInstrumentationKey = "string"
#       # daprConfiguration = {}
#       # infrastructureResourceGroup = "string"
#       # kedaConfiguration = {}
#       # openTelemetryConfiguration = {
#       #   destinationsConfiguration = {
#       #     dataDogConfiguration = {
#       #       key = "string"
#       #       site = "string"
#       #     }
#       #     otlpConfigurations = [
#       #       {
#       #         endpoint = "string"
#       #         headers = [
#       #           {
#       #             key = "string"
#       #             value = "string"
#       #           }
#       #         ]
#       #         insecure = bool
#       #         name = "string"
#       #       }
#       #     ]
#       #   }
#       #   logsConfiguration = {
#       #     destinations = [
#       #       "string"
#       #     ]
#       #   }
#       #   metricsConfiguration = {
#       #     destinations = [
#       #       "string"
#       #     ]
#       #   }
#       #   tracesConfiguration = {
#       #     destinations = [
#       #       "string"
#       #     ]
#       #   }
#       # }
#       # peerAuthentication = {
#       #   mtls = {
#       #     enabled = bool
#       #   }
#       # }
#       # vnetConfiguration = {
#       #   dockerBridgeCidr = "string"
#       #   infrastructureSubnetId = "string"
#       #   internal = bool
#       #   platformReservedCidr = "string"
#       #   platformReservedDnsIP = "string"
#       # }
#       # workloadProfiles = [
#       #   {
#       #     maximumCount = int
#       #     minimumCount = int
#       #     name = "string"
#       #     workloadProfileType = "string"
#       #   }
#       # ]
#       # zoneRedundant = bool
#     }
#     kind = "string"
#   })
# }