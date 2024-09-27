resource "azurerm_subnet" "gwe1_default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.gwe1.name
  address_prefixes     = ["10.1.1.0/26"]
}

resource "azurerm_subnet" "gwe1_psql" {
  name                 = "psql"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.gwe1.name
  address_prefixes     = ["10.1.1.64/26"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "gwe2_default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.gwe2.name
  address_prefixes     = ["10.1.2.0/26"]
}

resource "azurerm_subnet" "sc1_default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.sc1.name
  address_prefixes     = ["10.2.1.0/26"]
}

resource "azurerm_subnet" "sc2_default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.sc2.name
  address_prefixes     = ["10.2.2.0/26"]
}

resource "azurerm_subnet" "wus1_default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.wus1.name
  address_prefixes     = ["10.3.1.0/26"]
}

resource "azurerm_subnet" "wus2_default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.wus2.name
  address_prefixes     = ["10.3.2.0/26"]
}
