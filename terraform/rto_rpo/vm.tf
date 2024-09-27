resource "azurerm_network_interface" "main" {
  name                = "vm-${local.base_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                = "vm-${local.base_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B2ms"
  admin_username      = "tomas"
  admin_password      = "Azure12345678"
  zone                = 1
  computer_name       = "winvm"

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_site_recovery_replicated_vm" "main" {
  name                                      = "vm-${local.base_name}"
  resource_group_name                       = azurerm_resource_group.secondary.name
  recovery_vault_name                       = azurerm_recovery_services_vault.main.name
  source_recovery_fabric_name               = azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = azurerm_windows_virtual_machine.main.id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.main.id
  source_recovery_protection_container_name = azurerm_site_recovery_protection_container.primary.name
  target_resource_group_id                  = azurerm_resource_group.secondary.id
  target_recovery_fabric_id                 = azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id   = azurerm_site_recovery_protection_container.secondary.id
  target_zone                               = 2
  target_network_id                         = azurerm_virtual_network.secondary.id

  managed_disk {
    disk_id                    = "${azurerm_resource_group.main.id}/providers/Microsoft.Compute/disks/${azurerm_windows_virtual_machine.main.os_disk[0].name}"
    staging_storage_account_id = azurerm_storage_account.asr.id
    target_resource_group_id   = azurerm_resource_group.secondary.id
    target_disk_type           = "Premium_LRS"
    target_replica_disk_type   = "Premium_LRS"
  }

  network_interface {
    source_network_interface_id = azurerm_network_interface.main.id
    target_subnet_name          = "default"
  }

  depends_on = [
    azurerm_site_recovery_protection_container_mapping.main,
    azurerm_windows_virtual_machine.main,
  ]
}
