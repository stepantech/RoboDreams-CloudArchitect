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
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "location1_appgw" {
  name                 = "appgw"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location1.name
  address_prefixes     = ["10.0.1.0/24"]
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
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "location2_appgw" {
  name                 = "appgw"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.location2.name
  address_prefixes     = ["10.1.1.0/24"]
}
