resource "azurerm_traffic_manager_profile" "main" {
  name                   = "traf-${local.base_name}"
  resource_group_name    = azurerm_resource_group.main.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "traf-${local.base_name}"
    ttl           = 60
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "location_1" {
  name                 = "location_1"
  profile_id           = azurerm_traffic_manager_profile.main.id
  always_serve_enabled = true
  weight               = 100
  target_resource_id   = azurerm_public_ip.appgw_location1.id
}

resource "azurerm_traffic_manager_azure_endpoint" "location_2" {
  name                 = "location_2"
  profile_id           = azurerm_traffic_manager_profile.main.id
  always_serve_enabled = true
  weight               = 100
  target_resource_id   = azurerm_public_ip.appgw_location2.id
}
