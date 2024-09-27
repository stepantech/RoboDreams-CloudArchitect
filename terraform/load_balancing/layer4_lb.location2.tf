// Regional public IP for L4 LB
resource "azurerm_public_ip" "lb_location2" {
  name                = "pip-${local.base_name_regional2}-lb"
  location            = var.location2
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3]
  domain_name_label   = "${local.base_name_regional2}-l4"
}

// Load Balancer
resource "azurerm_lb" "lb_location2" {
  name                = "lb-${local.base_name_regional2}"
  location            = var.location2
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_location2.id
  }
}

// Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_location2" {
  loadbalancer_id = azurerm_lb.lb_location2.id
  name            = "pool"
}

// Probe
resource "azurerm_lb_probe" "lb_location2" {
  loadbalancer_id = azurerm_lb.lb_location2.id
  name            = "web-probe"
  port            = 80
}

// LB Rule
resource "azurerm_lb_rule" "lb_location2" {
  loadbalancer_id                = azurerm_lb.lb_location2.id
  name                           = "web"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb_location2.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_location2.id]
  probe_id                       = azurerm_lb_probe.lb_location2.id
}

// L4 LB assiciations
resource "azurerm_network_interface_backend_address_pool_association" "vm1_location2" {
  network_interface_id    = azurerm_network_interface.vm1_location2.id
  ip_configuration_name   = azurerm_network_interface.vm1_location2.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_location2.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2_location2" {
  network_interface_id    = azurerm_network_interface.vm2_location2.id
  ip_configuration_name   = azurerm_network_interface.vm2_location2.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_location2.id
}