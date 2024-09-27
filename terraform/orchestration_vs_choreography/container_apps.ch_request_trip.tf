resource "azurerm_container_app" "ch_request_trip" {
  name                         = "ca-ch-request-trip"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  dapr {
    app_id = "ca-ch-request-trip"
    # app_protocol = "grpc"
    # app_port = 3000
  }

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/ch_request_trip:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      # command = ["/bin/bash", "-c", "tail -f /dev/null"]

      env {
        name  = "PUBSUB_NAME"
        value = azurerm_container_app_environment_dapr_component.pubsub.name
      }

      env {
        name  = "TRIP_CREATED_TOPIC_NAME"
        value = "trip_created"
      }

      liveness_probe {
        path = "/healthz"
        port = 5000
        transport = "HTTP"
      }

      readiness_probe {
        path = "/healthz"
        port = 5000
        transport = "HTTP"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 5000

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }
}

