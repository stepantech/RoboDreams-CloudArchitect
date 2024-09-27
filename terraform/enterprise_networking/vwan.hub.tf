resource "azurerm_virtual_wan" "main" {
  name                = "vwan-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

resource "azurerm_virtual_hub" "gwe" {
  name                = "vhub-gwe-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "germanywestcentral"
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = "10.1.0.0/24"
  sku                 = "Standard"
}

resource "azurerm_virtual_hub" "sc" {
  name                = "vhub-sc-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "swedencentral"
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = "10.2.0.0/24"
  sku                 = "Standard"
}

resource "azurerm_virtual_hub" "wus" {
  name                = "vhub-wus-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "westus"
  virtual_wan_id      = azurerm_virtual_wan.main.id
  address_prefix      = "10.3.0.0/24"
  sku                 = "Standard"
}
