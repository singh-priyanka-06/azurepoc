provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "ABCResourceGroupWest3"
  location = "West US"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "ABCClusterWest3"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "ABCClusterWest3"

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



