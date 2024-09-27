resource "azurerm_virtual_network_peering" "l1_l2" {
  name                         = "l1-l2"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.location1.name
  remote_virtual_network_id    = azurerm_virtual_network.location2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "l1_l3" {
  name                         = "l1-l3"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.location1.name
  remote_virtual_network_id    = azurerm_virtual_network.location3.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "l2_l1" {
  name                         = "l2-l1"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.location2.name
  remote_virtual_network_id    = azurerm_virtual_network.location1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "l2_l3" {
  name                         = "l2-l3"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.location2.name
  remote_virtual_network_id    = azurerm_virtual_network.location3.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "l3_l1" {
  name                         = "l3-l1"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.location3.name
  remote_virtual_network_id    = azurerm_virtual_network.location1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "l3_l2" {
  name                         = "l3-l2"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.location3.name
  remote_virtual_network_id    = azurerm_virtual_network.location2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


