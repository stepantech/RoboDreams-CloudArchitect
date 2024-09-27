resource "azurerm_container_app_job" "json_producer" {
  name                         = "ca-json-producer"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  replica_retry_limit          = 2
  replica_timeout_in_seconds   = 3600

  manual_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
  }

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/json_producer:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "COUNT"
        value = "10000"
      }

      env {
        name  = "STORAGE_ACCOUNT_URL"
        value = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/"
      }

      env {
        name  = "CONTAINER_NAME"
        value = azurerm_storage_container.bronze.name
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.json_producer.client_id
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.json_producer.id]
  }
}

resource "azapi_resource_action" "start_manual_run" {
  type        = "Microsoft.App/jobs@2023-05-01"
  resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.App/jobs/${azurerm_container_app_job.json_producer.name}"
  action      = "start"
  method      = "POST"
  body        = jsonencode({})
}
