resource "azurerm_container_app" "auth_entra_api" {
  name                         = "ca-auth-entra-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 5001

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    min_replicas = 0
    max_replicas = 1

    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/auth_entra_api:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AUTHORITY"
        value = var.AUTHORITY
      }

      env {
        name  = "API_CLIENT_ID"
        value = var.API_CLIENT_ID
      }

      env {
        name  = "API_CLIENT_SECRET"
        value = var.API_CLIENT_SECRET
      }
    }
  }
}
