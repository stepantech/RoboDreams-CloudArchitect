resource "azurerm_container_app" "todo_ai" {
  name                         = "ca-todo-ai"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/todo_ai:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "SERVICE_BUS_TOPIC_NAME"
        value = azurerm_servicebus_topic.main.name
      }

      env {
        name  = "SERVICE_BUS_CONNECTION_STRING"
        value = azurerm_servicebus_topic_authorization_rule.consumer.primary_connection_string
      }

      env {
        name  = "SERVICE_BUS_SUBSCRIBER_NAME"
        value = azurerm_servicebus_subscription.consumer.name
      }

      env {
        name  = "TODO_BASE_URL"
        value = "https://${azurerm_container_app.todo_backend.ingress.0.fqdn}"
      }

      env {
        name  = "AZURE_OPENAI_API_KEY"
        value = var.AZURE_OPENAI_API_KEY
      }

      env {
        name  = "AZURE_OPENAI_ENDPOINT"
        value = var.AZURE_OPENAI_ENDPOINT
      }

      env {
        name  = "AZURE_OPENAI_DEPLOYMENT"
        value = "gpt-4o"
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
