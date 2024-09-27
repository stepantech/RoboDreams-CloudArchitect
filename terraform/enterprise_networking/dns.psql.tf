resource "azurerm_private_dns_zone" "psql" {
  name                = "tomas.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "gwe1_psql" {
  name                  = "psql-gwe1"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.psql.name
  virtual_network_id    = azurerm_virtual_network.gwe1.id
}
