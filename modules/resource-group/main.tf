variable "prefix" {
  default = "rg"
}

resource "azurerm_resource_group" "rg_01" {
  name     = "${var.prefix}-Platform"
  location = "East US"
}

resource "azurerm_resource_group" "rg_02" {
  name     = "${var.prefix}-Connectivity"
  location = "East US"
}

resource "azurerm_resource_group" "rg_03" {
  name     = "${var.prefix}-AppLandingZone"
  location = "East US"
}