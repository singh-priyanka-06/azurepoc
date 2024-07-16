provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "ABCResourceGroupCentral"
  location = "Central US"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "ABCCluster"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "ABCCluster"

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



