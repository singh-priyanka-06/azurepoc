provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "ABCResourceGroup"
  location = "Central US"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "ABCClusterCentral"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "ABCClusterCentral"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}



