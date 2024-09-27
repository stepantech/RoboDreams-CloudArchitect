resource "azurerm_virtual_hub_connection" "gwe1" {
  name                      = "vhc-gwe1-${local.base_name}"
  virtual_hub_id            = azurerm_virtual_hub.gwe.id
  remote_virtual_network_id = azurerm_virtual_network.gwe1.id
}

resource "azurerm_virtual_hub_connection" "gwe2" {
  name                      = "vhc-gwe2-${local.base_name}"
  virtual_hub_id            = azurerm_virtual_hub.gwe.id
  remote_virtual_network_id = azurerm_virtual_network.gwe2.id
}

resource "azurerm_virtual_hub_connection" "sc1" {
  name                      = "vhc-sc1-${local.base_name}"
  virtual_hub_id            = azurerm_virtual_hub.sc.id
  remote_virtual_network_id = azurerm_virtual_network.sc1.id
}

resource "azurerm_virtual_hub_connection" "sc2" {
  name                      = "vhc-sc2-${local.base_name}"
  virtual_hub_id            = azurerm_virtual_hub.sc.id
  remote_virtual_network_id = azurerm_virtual_network.sc2.id
}

resource "azurerm_virtual_hub_connection" "wus1" {
  name                      = "vhc-wus1-${local.base_name}"
  virtual_hub_id            = azurerm_virtual_hub.wus.id
  remote_virtual_network_id = azurerm_virtual_network.wus1.id
}

resource "azurerm_virtual_hub_connection" "wus2" {
  name                      = "vhc-wus2-${local.base_name}"
  virtual_hub_id            = azurerm_virtual_hub.wus.id
  remote_virtual_network_id = azurerm_virtual_network.wus2.id
}