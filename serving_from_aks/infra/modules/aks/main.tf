resource "azurerm_kubernetes_cluster" "edu-k8s" {
  name                = "edu-k8s-${var.tag}"
  location            = var.location
  resource_group_name = var.azurerm_resource_group.name
  dns_prefix          = "eduk8s${var.tag}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.tag
  }
}

## Install FluxCD on the cluster
#resource "azurerm_kubernetes_cluster_extension" "fluxcd" {
#  name           = "fluxcd-${var.tag}"
#  cluster_id     = azurerm_kubernetes_cluster.edu-k8s.id
#  extension_type = "microsoft.flux"
#}
