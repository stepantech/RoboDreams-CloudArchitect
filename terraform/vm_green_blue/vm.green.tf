resource "azurerm_network_interface" "green" {
  count               = var.green_count
  name                = "nic-${local.base_name}-green${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "green" {
  count                           = var.green_count
  name                            = "vm-${local.base_name}-green${count.index}"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  user_data                       = local.vm_green_script
  zone                            = (count.index % 3) + 1 # Assign to 3 zones in sequence using modulo operator
  computer_name                   = "green${count.index}"

  network_interface_ids = [
    azurerm_network_interface.green[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_nat_gateway.main,
    azurerm_nat_gateway_public_ip_association.main,
    azurerm_subnet_nat_gateway_association.main
  ]
}

resource "azurerm_network_interface_backend_address_pool_association" "green" {
  count                   = var.green_count
  network_interface_id    = azurerm_network_interface.green[count.index].id
  ip_configuration_name   = azurerm_network_interface.green[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}
