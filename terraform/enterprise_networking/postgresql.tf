resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "psql-${local.base_name}"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = "germanywestcentral"
  version                       = "12"
  delegated_subnet_id           = azurerm_subnet.gwe1_psql.id
  private_dns_zone_id           = azurerm_private_dns_zone.psql.id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = "H@Sh1CoR3!"
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P30"

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.gwe1_psql]
}