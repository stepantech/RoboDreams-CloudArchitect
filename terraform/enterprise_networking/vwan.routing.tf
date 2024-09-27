resource "azurerm_virtual_hub_routing_intent" "gwe" {
  name           = "routing-intent-gwe-${local.base_name}"
  virtual_hub_id = azurerm_virtual_hub.gwe.id

  routing_policy {
    name         = "TrafficPolicy"
    destinations = ["Internet", "PrivateTraffic"]
    next_hop     = azurerm_firewall.gwe.id
  }
}

resource "azurerm_virtual_hub_routing_intent" "sc" {
  name           = "routing-intent-sc-${local.base_name}"
  virtual_hub_id = azurerm_virtual_hub.sc.id

  routing_policy {
    name         = "TrafficPolicy"
    destinations = ["Internet", "PrivateTraffic"]
    next_hop     = azurerm_firewall.sc.id
  }
}

resource "azurerm_virtual_hub_routing_intent" "wus" {
  name           = "routing-intent-wus-${local.base_name}"
  virtual_hub_id = azurerm_virtual_hub.wus.id

  routing_policy {
    name         = "TrafficPolicy"
    destinations = ["Internet", "PrivateTraffic"]
    next_hop     = azurerm_firewall.wus.id
  }
}