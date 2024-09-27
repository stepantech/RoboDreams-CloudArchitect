resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.base_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-${local.base_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network" "secondary" {
  name                = "vnet-${local.secondary_name}"
  location            = var.location_secondary
  resource_group_name = azurerm_resource_group.secondary.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "secondary" {
  name                 = "subnet-${local.secondary_name}"
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.secondary.name
  address_prefixes     = ["10.1.0.0/24"]
}
