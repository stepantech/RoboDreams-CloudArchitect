resource "azurerm_container_app" "read_write_tradeoff" {
  name                         = "ca-read-write-tradeoff"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/read_write_tradeoff:latest"
      cpu    = 2
      memory = "4Gi"

      env {
        name  = "PGHOST"
        value = azurerm_postgresql_flexible_server.main.fqdn
      }

      env {
        name  = "PGPASSWORD"
        value = azurerm_postgresql_flexible_server.main.administrator_password
      }

      env {
        name  = "ROWS_COUNT"
        value = "100000"
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.read_write_tradeoff.client_id
      }

      env {
        name  = "STORAGE_ACCOUNT_URL"
        value = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/"
      }

      env {
        name  = "CONTAINER_NAME"
        value = azurerm_storage_container.data.name
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.read_write_tradeoff.id]
  }
}
