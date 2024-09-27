resource "azurerm_container_app_environment_dapr_component" "pubsub" {
  name                         = "pubsub"
  container_app_environment_id = azurerm_container_app_environment.main.id
  component_type               = "pubsub.azure.servicebus.topics"
  version                      = "v1"

  metadata {
    name  = "namespaceName"
    value = "${azurerm_servicebus_namespace.main.name}.servicebus.windows.net"
  }

  metadata {
    name  = "azureClientID"
    value = azurerm_user_assigned_identity.app.client_id
  }
}

resource "azurerm_container_app_environment_dapr_component" "state" {
  name                         = "state"
  container_app_environment_id = azurerm_container_app_environment.main.id
  component_type               = "state.azure.cosmosdb"
  version                      = "v1"

  metadata {
    name  = "url"
    value = azurerm_cosmosdb_account.main.endpoint
  }

  metadata {
    name  = "database"
    value = azurerm_cosmosdb_sql_database.main.name
  }

  metadata {
    name  = "collection"
    value = azurerm_cosmosdb_sql_container.main.name
  }

  metadata {
    name  = "azureClientID"
    value = azurerm_user_assigned_identity.app.client_id
  }
}
