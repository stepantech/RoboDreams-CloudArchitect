resource "azurerm_virtual_network" "gwe1" {
  name                = "vnet-gwe1-${local.base_name}"
  address_space       = ["10.1.1.0/24"]
  location            = "germanywestcentral"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "gwe2" {
  name                = "vnet-gwe2-${local.base_name}"
  address_space       = ["10.1.2.0/24"]
  location            = "germanywestcentral"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "sc1" {
  name                = "vnet-sc1-${local.base_name}"
  address_space       = ["10.2.1.0/24"]
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "sc2" {
  name                = "vnet-sc2-${local.base_name}"
  address_space       = ["10.2.2.0/24"]
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "wus1" {
  name                = "vnet-wus1-${local.base_name}"
  address_space       = ["10.3.1.0/24"]
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_network" "wus2" {
  name                = "vnet-wus2-${local.base_name}"
  address_space       = ["10.3.2.0/24"]
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name
}
