resource "azurerm_virtual_network" "location1" {
  name                = "vnet-${local.base_name_regional1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "location1" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location1.name
  address_prefixes     = ["10.0.0.0/18"]
}

resource "azurerm_subnet" "location1_management" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location1.name
  address_prefixes     = ["10.0.64.0/18"]
}

resource "azurerm_subnet" "location1_containerapp" {
  name                 = "containerapp"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location1.name
  address_prefixes     = ["10.0.128.0/18"]
}

resource "azurerm_virtual_network" "location2" {
  name                = "vnet-${local.base_name_regional2}"
  location            = var.location2
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.1.0.0/16"]

}

resource "azurerm_subnet" "location2" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location2.name
  address_prefixes     = ["10.1.0.0/18"]
}

resource "azurerm_virtual_network" "location3" {
  name                = "vnet-${local.base_name_regional3}"
  location            = var.location3
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.2.0.0/16"]

}

resource "azurerm_subnet" "location3" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location3.name
  address_prefixes     = ["10.2.0.0/18"]
}

