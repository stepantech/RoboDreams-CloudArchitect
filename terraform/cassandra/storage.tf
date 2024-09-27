// Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "st${local.base_name_nodash}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

// Storage containers
resource "azurerm_storage_container" "myfiles" {
  name                  = "myfiles"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
