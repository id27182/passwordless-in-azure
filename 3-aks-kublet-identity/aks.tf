# Deploy Kubernetes cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.rg_name}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.rg_name}-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  # This block is required in order to enable managed identity for master
  # node. Kubelet managed identity is created automatically, regardless of 
  # which identity is used for master.
  identity {
    type = "SystemAssigned"
  }
}

# Enable AKS kubelet identity to use storage account tables 
resource "azurerm_role_assignment" "backend_web_app_to_storage_account" {
    scope                = azurerm_storage_account.backend.id
    role_definition_name = "Storage Table Data Contributor"
    principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
