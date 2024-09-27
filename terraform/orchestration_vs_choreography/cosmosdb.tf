// Cosmos DB Account
resource "azurerm_cosmosdb_account" "main" {
  name                             = "cosmos-${local.base_name}"
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
  offer_type                       = "Standard"
  kind                             = "GlobalDocumentDB"
  multiple_write_locations_enabled = false
  public_network_access_enabled = true
  # ip_range_filter                  = "0.0.0.0/0"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "mydb"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
}

resource "azurerm_cosmosdb_sql_container" "main" {
  name                  = "mytable"
  resource_group_name   = azurerm_resource_group.main.name
  account_name          = azurerm_cosmosdb_account.main.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths   = ["/key"]
  partition_key_version = 2
  throughput            = 400
}
