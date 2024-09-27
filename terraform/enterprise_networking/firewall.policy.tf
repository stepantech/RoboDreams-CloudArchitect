resource "azurerm_firewall_policy" "gwe" {
  name                = "fpol-gwe-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "germanywestcentral"
  sku                 = "Premium"
}

resource "azurerm_firewall_policy" "sc" {
  name                = "fpol-sc-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "swedencentral"
  sku                 = "Premium"
}

resource "azurerm_firewall_policy" "wus" {
  name                = "fpol-wus-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = "westus"
  sku                 = "Premium"
}
