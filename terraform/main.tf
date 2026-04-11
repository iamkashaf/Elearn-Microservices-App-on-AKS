resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "dev"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devopsaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    #vm_size    = "Standard_DS2_v2"
    vm_size    = "Standard_B2ms"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}