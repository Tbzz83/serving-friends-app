output "client_certificate" {
  value     = module.azurerm_kubernetes_cluster.client_certificate
  sensitive = true
}

output "kube_config" {
  value = module.azurerm_kubernetes_cluster.kube_config
  sensitive = true
}