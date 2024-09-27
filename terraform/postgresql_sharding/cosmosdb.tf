// Single-node
resource "azurerm_cosmosdb_postgresql_cluster" "single" {
  name                                 = "cospos-single-${local.base_name}"
  resource_group_name                  = azurerm_resource_group.main.name
  location                             = azurerm_resource_group.main.location
  administrator_login_password         = "Azure12345678"
  coordinator_server_edition           = "GeneralPurpose"
  coordinator_public_ip_access_enabled = true
  coordinator_storage_quota_in_mb      = 2097152
  coordinator_vcore_count              = 8
  node_count                           = 0
}

resource "azurerm_cosmosdb_postgresql_firewall_rule" "single" {
  name             = "all"
  cluster_id       = azurerm_cosmosdb_postgresql_cluster.single.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

// Multi-node
resource "azurerm_cosmosdb_postgresql_cluster" "multi" {
  name                                 = "cospos-multi-${local.base_name}"
  resource_group_name                  = azurerm_resource_group.main.name
  location                             = azurerm_resource_group.main.location
  administrator_login_password         = "Azure12345678"
  coordinator_server_edition           = "GeneralPurpose"
  coordinator_public_ip_access_enabled = true
  coordinator_storage_quota_in_mb      = 131072
  coordinator_vcore_count              = 2
  node_count                           = 4
  node_server_edition                  = "GeneralPurpose"
  node_public_ip_access_enabled        = true
  node_storage_quota_in_mb             = 524288
  node_vcores                          = 2
}

resource "azurerm_cosmosdb_postgresql_firewall_rule" "multi" {
  name             = "all"
  cluster_id       = azurerm_cosmosdb_postgresql_cluster.multi.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}