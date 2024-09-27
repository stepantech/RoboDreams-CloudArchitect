resource "azurerm_container_app" "todo_frontend" {
  name                         = "ca-todo-frontend"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/todo_frontend:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "BACKEND_BASE_URL"
        value = "https://${azurerm_container_app.todo_backend.ingress.0.fqdn}"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
