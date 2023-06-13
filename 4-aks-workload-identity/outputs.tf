output aks_name {
  value       = azurerm_kubernetes_cluster.main.name
  sensitive   = false
  description = "Name of created AKS cluster"
}

output aks_rg { 
    value       = azurerm_resource_group.main.name
    sensitive   = false
    description = "Name of the resource group, where AKS cluster was deployed" 
}
