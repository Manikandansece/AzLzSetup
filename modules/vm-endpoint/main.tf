# Configure the Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-AppLandingZone"
  location = "East US"
}

variable "appsubnet_id" {
  type = string
}

resource "azurerm_network_interface" "mynetworkinterface" {
  name                = "my-network-interface"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.appsubnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows 11 Virtual Machine
resource "azurerm_windows_virtual_machine" "avdvm1" {
  name                = "windows11-21h2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.my_virtual_machine_size
  admin_username      = "adminuser"
  admin_password      = var.my_virtual_machine_password
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  name                       = "vmext-AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.avdvm1.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}