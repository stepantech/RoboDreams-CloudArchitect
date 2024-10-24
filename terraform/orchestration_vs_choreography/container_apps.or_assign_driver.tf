resource "azurerm_container_app" "or_assign_driver" {
  name                         = "ca-or-assign-driver"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/or_assign_driver:latest"
      cpu    = 0.25
      memory = "0.5Gi"

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

