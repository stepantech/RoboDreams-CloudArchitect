resource "azurerm_cosmosdb_cassandra_cluster" "main" {
  name                           = "coscas-${local.base_name}"
  resource_group_name            = azurerm_resource_group.main.name
  location                       = var.location
  delegated_management_subnet_id = azurerm_subnet.location1_management.id
  default_admin_password         = "Azure12345678"
  version                        = "4.0"

  depends_on = [azurerm_role_assignment.cosmosdb]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "location1" {
  name                           = "r-${lookup(local.short_region_lookup, var.location, "other")}"
  location                       = var.location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.main.id
  delegated_management_subnet_id = azurerm_subnet.location1.id
  node_count                     = 3
  disk_count                     = 1
  sku_name                       = "Standard_D8as_v5"
  availability_zones_enabled     = true
}

resource "azurerm_cosmosdb_cassandra_datacenter" "location2" {
  name                           = "r-${lookup(local.short_region_lookup, var.location2, "other")}"
  location                       = var.location2
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.main.id
  delegated_management_subnet_id = azurerm_subnet.location2.id
  node_count                     = 3
  disk_count                     = 1
  sku_name                       = "Standard_D8as_v5"
  availability_zones_enabled     = true

  depends_on = [azurerm_cosmosdb_cassandra_datacenter.location1]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "location3" {
  name                           = "r-${lookup(local.short_region_lookup, var.location3, "other")}"
  location                       = var.location3
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.main.id
  delegated_management_subnet_id = azurerm_subnet.location3.id
  node_count                     = 3
  disk_count                     = 1
  sku_name                       = "Standard_D8as_v5"
  availability_zones_enabled     = true

  depends_on = [azurerm_cosmosdb_cassandra_datacenter.location2]
}
