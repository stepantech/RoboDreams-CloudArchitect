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
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

// Upload
resource "azurerm_storage_blob" "csv" {
  name                   = "example/mydata.csv"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "files/mydata.csv"
}


resource "azurerm_storage_blob" "lending_club" {
  name                   = "example/lending_club.csv"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "files/lending_club.csv"
}

