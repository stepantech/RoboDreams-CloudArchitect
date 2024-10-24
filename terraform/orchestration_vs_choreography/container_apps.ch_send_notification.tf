resource "azurerm_container_app" "ch_send_notification" {
  name                         = "ca-ch-send-notification"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  dapr {
    app_id       = "ca-ch-send-notification"
    app_protocol = "grpc"
    app_port     = 5000
  }

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/ch_send_notification:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "PUBSUB_NAME"
        value = azurerm_container_app_environment_dapr_component.pubsub.name
      }

      env {
        name  = "TRIP_CREATED_TOPIC_NAME"
        value = "trip_created"
      }

      env {
        name  = "DRIVER_ASSIGNED_TOPIC_NAME"
        value = "driver_assigned"
      }
    }

    custom_scale_rule {
      name             = "messages"
      custom_rule_type = "azure-servicebus"
      metadata = {
        topicName        = "trip_created"
        subscriptionName = "ca-ch-send-notification"
        messageCount     = 3
        azureClientID    = azurerm_user_assigned_identity.app.client_id
      }
    }

    custom_scale_rule {
      name             = "messages"
      custom_rule_type = "azure-servicebus"
      metadata = {
        topicName        = "driver_assigned"
        subscriptionName = "ca-ch-send-notification"
        messageCount     = 3
        azureClientID    = azurerm_user_assigned_identity.app.client_id
      }
    }
  }


  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }
}

