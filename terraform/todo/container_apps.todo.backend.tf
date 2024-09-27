resource "azurerm_container_app" "todo_backend" {
  name                         = "ca-todo-backend"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/todo_backend:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "PG_USER"
        value = azurerm_postgresql_flexible_server.main.administrator_login
      }

      env {
        name  = "PG_PASSWORD"
        value = azurerm_postgresql_flexible_server.main.administrator_password
      }

      env {
        name  = "PG_HOST"
        value = azurerm_postgresql_flexible_server.main.fqdn
      }

      env {
        name  = "PG_PORT"
        value = 5432
      }

      env {
        name  = "PG_DB"
        value = "postgres"
      }

      env {
        name  = "SERVICE_BUS_TOPIC_NAME"
        value = azurerm_servicebus_topic.main.name
      }

      env {
        name  = "SERVICE_BUS_CONNECTION_STRING"
        value = azurerm_servicebus_topic_authorization_rule.producer.primary_connection_string
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
