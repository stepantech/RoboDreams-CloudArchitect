resource "azurerm_storage_account" "main" {
  name                     = "st${local.base_name_nodash}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = "germanywestcentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pe-blob-${local.base_name}"
  location            = "germanywestcentral"
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.gwe1_default.id

  private_service_connection {
    name                           = "psc-blob-${local.base_name}"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-blob-${local.base_name}"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}
