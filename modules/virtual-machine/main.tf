variable "prefix" {
  default = "azw-dc-001"
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${var.prefix}"
  location            = "East US"
  resource_group_name = "rg-Platform"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "/subscriptions/4704282e-9375-4a08-bfa9-2101ed40b8dc/resourceGroups/rg-Connectivity/providers/Microsoft.Network/virtualNetworks/vnet-landingzone/subnets/iam-subnet"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}"
  location              = azurerm_network_interface.main.location
  resource_group_name   = azurerm_network_interface.main.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_D4s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.prefix
    admin_username = "ciabadmin"
    admin_password = "ciabPassw0rd2025!"
  }
  os_profile_windows_config {
    provision_vm_agent  = true
    enable_automatic_upgrades = true
  }
  tags = {
    environment = "dev"
  }
}