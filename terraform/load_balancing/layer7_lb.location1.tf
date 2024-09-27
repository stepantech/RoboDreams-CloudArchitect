resource "azurerm_public_ip" "appgw_location1" {
  name                = "pip-${local.base_name_regional1}-appgw"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3]
  domain_name_label   = "${local.base_name_regional1}-l7"
}


resource "azurerm_application_gateway" "appgw_location1" {
  name                = "agw-${local.base_name_regional1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.appgw_location1.id

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.location1_appgw.id
  }

  frontend_port {
    name = "frontport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontip"
    public_ip_address_id = azurerm_public_ip.appgw_location1.id
  }

  backend_address_pool {
    name = "mainservice"
  }

  backend_address_pool {
    name = "service2"
  }

  backend_http_settings {
    name                  = "httpsettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontip"
    frontend_port_name             = "frontport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "web"
    priority                   = 1
    rule_type                  = "PathBasedRouting"
    http_listener_name         = "listener"
    backend_address_pool_name  = "mainservice"
    backend_http_settings_name = "httpsettings"
    url_path_map_name          = "myservices"
  }

  url_path_map {
    name                               = "myservices"
    default_backend_address_pool_name  = "mainservice"
    default_backend_http_settings_name = "httpsettings"

    path_rule {
      name                       = "service2"
      paths                      = ["/service2/*", "/service2"]
      backend_address_pool_name  = "service2"
      backend_http_settings_name = "httpsettings"
    }
  }
}

resource "azurerm_web_application_firewall_policy" "appgw_location1" {
  name                = "waf-${local.base_name_regional1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  policy_settings {
    enabled                          = true
    mode                             = "Prevention"
    file_upload_limit_in_mb          = 100
    max_request_body_size_in_kb      = 128
    request_body_check               = true
    request_body_inspect_limit_in_kb = 128
  }
}

// L7 LB association
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "vm1_location1" {
  network_interface_id    = azurerm_network_interface.vm1_location1.id
  ip_configuration_name   = azurerm_network_interface.vm1_location1.ip_configuration[0].name
  backend_address_pool_id = "${azurerm_application_gateway.appgw_location1.id}/backendAddressPools/mainservice"
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "vm2_location1" {
  network_interface_id    = azurerm_network_interface.vm2_location1.id
  ip_configuration_name   = azurerm_network_interface.vm2_location1.ip_configuration[0].name
  backend_address_pool_id = "${azurerm_application_gateway.appgw_location1.id}/backendAddressPools/mainservice"
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "vm4_location1" {
  network_interface_id    = azurerm_network_interface.vm4_location1.id
  ip_configuration_name   = azurerm_network_interface.vm4_location1.ip_configuration[0].name
  backend_address_pool_id = "${azurerm_application_gateway.appgw_location1.id}/backendAddressPools/service2"
}
