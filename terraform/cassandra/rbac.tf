resource "azurerm_role_assignment" "cosmosdb" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Network Contributor"
  principal_id         = var.cosmos_db_service_principal_id
}

resource "azurerm_role_assignment" "cassandra_client" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.cassandra_client.principal_id
}
