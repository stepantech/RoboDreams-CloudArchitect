// Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "afd-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Premium_AzureFrontDoor"
}

// Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "fde-${local.base_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

// Front Door Firewall Policy
resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  name                = "fdfp${local.base_name_nodash}"
  resource_group_name = azurerm_resource_group.main.name
  mode                = "Prevention"
  sku_name            = "Premium_AzureFrontDoor"
  enabled             = true

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }
}

// Front Door Origin Groups
resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                                                      = "main-web-group"
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled                                  = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0

  health_probe {
    interval_in_seconds = 10
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "service2" {
  name                                                      = "service2-group"
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled                                  = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0

  health_probe {
    interval_in_seconds = 10
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "newversion" {
  name                                                      = "newversion-group"
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled                                  = true
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0

  health_probe {
    interval_in_seconds = 10
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

// Front Door Origins
resource "azurerm_cdn_frontdoor_origin" "main_location1" {
  name                           = "web-location1"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_public_ip.appgw_location1.fqdn
  http_port                      = 80
  origin_host_header             = azurerm_public_ip.appgw_location1.fqdn
  priority                       = 1
  weight                         = 1
}

resource "azurerm_cdn_frontdoor_origin" "main_location2" {
  name                           = "web-location2"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_public_ip.appgw_location2.fqdn
  http_port                      = 80
  origin_host_header             = azurerm_public_ip.appgw_location2.fqdn
  priority                       = 1
  weight                         = 1
}

resource "azurerm_cdn_frontdoor_origin" "service2_location1" {
  name                           = "service2-location1"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.service2.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_public_ip.service2_location1.fqdn
  http_port                      = 80
  origin_host_header             = azurerm_public_ip.service2_location1.fqdn
  priority                       = 1
  weight                         = 1
}

resource "azurerm_cdn_frontdoor_origin" "service2_location2" {
  name                           = "service2-location2"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.service2.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_public_ip.service2_location2.fqdn
  http_port                      = 80
  origin_host_header             = azurerm_public_ip.service2_location2.fqdn
  priority                       = 1
  weight                         = 1
}

resource "azurerm_cdn_frontdoor_origin" "newversion_location1" {
  name                           = "newversion-location1"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.newversion.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_public_ip.newversion_location1.fqdn
  http_port                      = 80
  origin_host_header             = azurerm_public_ip.newversion_location1.fqdn
  priority                       = 1
  weight                         = 1
}

resource "azurerm_cdn_frontdoor_origin" "newversion_location2" {
  name                           = "newversion-location2"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.newversion.id
  enabled                        = true
  certificate_name_check_enabled = false
  host_name                      = azurerm_public_ip.newversion_location2.fqdn
  http_port                      = 80
  origin_host_header             = azurerm_public_ip.newversion_location2.fqdn
  priority                       = 1
  weight                         = 1
}

// Front Foor Routes
resource "azurerm_cdn_frontdoor_route" "main" {
  name                          = "main-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.main_location1.id]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "HttpOnly"
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  link_to_default_domain        = true
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.main.id]
}

resource "azurerm_cdn_frontdoor_route" "service2" {
  name                          = "service2-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.service2.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.service2_location1.id]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "HttpOnly"
  https_redirect_enabled        = true
  patterns_to_match             = ["/service2", "/service2/*"]
  link_to_default_domain        = true
  cdn_frontdoor_origin_path     = "/"
}

// Beta-testing newversion rule
resource "azurerm_cdn_frontdoor_rule_set" "main" {
  name                     = "betatesting"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_rule" "main" {
  name                      = "betatesters"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.main.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    route_configuration_override_action {
      cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.newversion.id
      forwarding_protocol           = "HttpOnly"
      cache_behavior                = "Disabled"
    }
  }

  conditions {
    request_header_condition {
      header_name  = "Beta-Tester"
      operator     = "Equal"
      match_values = ["true"]
    }
  }

  depends_on = [
    azurerm_cdn_frontdoor_origin.newversion_location1,
    azurerm_cdn_frontdoor_origin.newversion_location2
  ]
}
