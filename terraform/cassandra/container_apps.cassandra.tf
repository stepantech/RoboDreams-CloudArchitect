resource "azurerm_container_app" "cassandra" {
  name                         = "ca-cassandra"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "myapp"
      image  = "ghcr.io/tkubica12/cloud-arch-app-data/cassandra_demo:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "CASSANDRA_USERNAME"
        value = "cassandra"
      }

      env {
        name  = "CASSANDRA_PASSWORD"
        value = azurerm_cosmosdb_cassandra_cluster.main.default_admin_password
      }

      env {
        name  = "CASSANDRA_IPS"
        value = jsonencode(azurerm_cosmosdb_cassandra_datacenter.location1.seed_node_ip_addresses)
      }

      env {
        name  = "CASSANDRA_DC1"
        value = azurerm_cosmosdb_cassandra_datacenter.location1.name
      }

      env {
        name  = "CASSANDRA_DC2"
        value = azurerm_cosmosdb_cassandra_datacenter.location2.name
      }

      env {
        name  = "CASSANDRA_DC3"
        value = azurerm_cosmosdb_cassandra_datacenter.location3.name
      }

      env {
        name  = "STORAGE_ACCOUNT_URL"
        value = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/"
      }

      env {
        name  = "CONTAINER_NAME"
        value = azurerm_storage_container.myfiles.name
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.cassandra_client.client_id
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cassandra_client.id]
  }
}
