#provider "azurerm" {
#  features {}
#}

# Configure the Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-Connectivity"
  location = "East US"
}

# Create the Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-landingzone"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

# Create Subnets within the Virtual Network
resource "azurerm_subnet" "iamsubnet" {
  name                 = "iam-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "appsubnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "bastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_public_ip" "bastionpip" {
  name                = "bastionpip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastionhost" {
  name                = "bastionhost"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}

# Create Network Security Group (NSG) for the subnets
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-landingzone"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Associate NSG with Subnet 1
resource "azurerm_subnet_network_security_group_association" "iamsubnet_nsg" {
  subnet_id                  = azurerm_subnet.iamsubnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Associate NSG with Subnet 2
resource "azurerm_subnet_network_security_group_association" "appsubnet_nsg" {
  subnet_id                  = azurerm_subnet.appsubnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
