# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
backend "azurerm" {
      resource_group_name  = "rg_automation_tf"
      storage_account_name = "stgcloudshellparentco"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "mgmt_group" {
  source = "./modules/management-group"  
}

module "resource_group" {
  source = "./modules/resource-group"  
}

module "virtual_network" {
  source = "./modules/virtual-network"
}

module "virtual_machine" {
  source = "./modules/virtual-machine"
}
