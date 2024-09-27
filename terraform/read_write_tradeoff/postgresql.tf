resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "psql-${local.base_name}"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "12"
  public_network_access_enabled = true
  administrator_login           = "psqladmin"
  administrator_password        = "Azure12345678"
  zone                          = "1"
  storage_mb                    = 1048576
  storage_tier                  = "P30"
  sku_name                      = "GP_Standard_D4ds_v5"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "main" {
  name             = "all"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "mydb"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
