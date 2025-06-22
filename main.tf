terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-ovi-rg"
    storage_account_name = "ovitfstatestorage"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "prefix" {
  default = "go-web-app-devops"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
  dns_prefix = "${var.prefix}-k8s"
}
