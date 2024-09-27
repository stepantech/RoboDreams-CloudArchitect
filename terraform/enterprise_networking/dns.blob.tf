resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_gwe1" {
  name                  = "blob-gwe1"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.gwe1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_gwe2" {
  name                  = "blob-gwe2"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.gwe2.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_sc1" {
  name                  = "blob-sc1"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.sc1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_sc2" {
  name                  = "blob-sc2"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.sc2.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_wus1" {
  name                  = "blob-wus1"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.wus1.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_wus2" {
  name                  = "blob-wus2"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.wus2.id
}
