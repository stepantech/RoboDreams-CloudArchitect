resource "azurerm_firewall" "gwe" {
  name                = "fw-gwe-${local.base_name}"
  location            = "germanywestcentral"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.gwe.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.gwe.id
    public_ip_count = 1
  }
}

resource "azurerm_firewall" "sc" {
  name                = "fw-sc-${local.base_name}"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.sc.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.sc.id
    public_ip_count = 1
  }
}

resource "azurerm_firewall" "wus" {
  name                = "fw-wus-${local.base_name}"
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.wus.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.wus.id
    public_ip_count = 1
  }
}
