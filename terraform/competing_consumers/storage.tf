resource "azurerm_storage_account" "main" {
  name                     = "st${local.base_name_nodash}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "consumer1" {
  name                  = "consumer1"
  storage_account_name  = azurerm_storage_account.main.name
}

resource "azurerm_storage_container" "consumer2" {
  name                  = "consumer2"
  storage_account_name  = azurerm_storage_account.main.name
}