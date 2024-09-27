resource "azurerm_container_app" "sb_consumer1" {
  name                         = "ca-sb-consumer1"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/sb_consumer:latest"
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
        name  = "SB_SUBSCRIPTION_NAME"
        value = azurerm_servicebus_subscription.consumer1.name
      }

      env {
        name  = "BATCH_SIZE"
        value = "3"
      }

      env {
        name  = "PROCESSING_TIME"
        value = "5"
      }

      env {
        name  = "STORAGE_ACCOUNT_URL"
        value = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/"
      }

      env {
        name  = "CONTAINER_NAME"
        value = azurerm_storage_container.consumer1.name
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.sb_consumer.client_id
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.sb_consumer.id]
  }
}

resource "azurerm_container_app" "sb_consumer2" {
  name                         = "ca-sb-consumer2"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/sb_consumer:latest"
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
        name  = "SB_SUBSCRIPTION_NAME"
        value = azurerm_servicebus_subscription.consumer2.name
      }

      env {
        name  = "BATCH_SIZE"
        value = "3"
      }

      env {
        name  = "PROCESSING_TIME"
        value = "5"
      }

      env {
        name  = "STORAGE_ACCOUNT_URL"
        value = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/"
      }

      env {
        name  = "CONTAINER_NAME"
        value = azurerm_storage_container.consumer2.name
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.sb_consumer.client_id
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.sb_consumer.id]
  }
}

