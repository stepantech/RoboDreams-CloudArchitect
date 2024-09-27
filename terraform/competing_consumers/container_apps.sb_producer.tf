resource "azurerm_container_app" "sb_producer" {
  name                         = "ca-sb-producer"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/sb_producer:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "SB_FQDN"
        value = "${azurerm_servicebus_namespace.main.name}.servicebus.windows.net"
      }

      env {
        name  = "TOPIC_NAME"
        value = azurerm_servicebus_topic.main.name
      }

      env {
        name  = "RATE"
        value = "30"
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.sb_producer.client_id
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.sb_producer.id]
  }
}
