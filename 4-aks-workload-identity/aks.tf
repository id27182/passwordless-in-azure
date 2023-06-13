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

  # Enable workload identity support for the AKS cluster:
  oidc_issuer_enabled       = true 
  workload_identity_enabled = true
}

# Create a user-assigned managed identity, which will be used by 
# our application
resource "azurerm_user_assigned_identity" "backend_identity" {
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  name                = "${var.rg_name}-ba-uami"
}

# Map kubernetes service account, which will be used by our application 
# to the managed identity we created and autorised to use our backend storage 
resource "azurerm_federated_identity_credential" "backend_identity" {
  name                = "${var.rg_name}-ba-federated-credentials"
  resource_group_name = azurerm_resource_group.main.name
  audience            = ["api://AzureADTokenExchange"] # This one is static
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.backend_identity.id
  
  # In subject we are specifying, to which kubernetes service account in 
  # which cluster namespace we map the managed identity we created. The 
  # format of the subject: 
  # "system:serviceaccount:<namespace>:<service account name>"
  subject             = "system:serviceaccount:default:backend-app"
}

# Enable managed identity we created to use storage account tables 
resource "azurerm_role_assignment" "backend_web_app_to_storage_account" {
  scope                = azurerm_storage_account.backend.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_user_assigned_identity.backend_identity.principal_id
}
