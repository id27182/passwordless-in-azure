resource "azurerm_service_plan" "backend" {
    name                = "${var.rg_name}-ba-asp"
    resource_group_name = azurerm_resource_group.main.name
    location            = var.location
    os_type             = "Linux"
    sku_name            = var.app_service_plan_sku
}

resource "azurerm_linux_web_app" "backend" {
    name                = "${var.rg_name}-ba-app"
    resource_group_name = azurerm_resource_group.main.name
    location            = var.location
    service_plan_id     = azurerm_service_plan.backend.id
    site_config {}   

    app_settings = {
        storage_account_name = azurerm_storage_account.backend.name
    }
    
    # Enable system-assigned managed identity on the web app 
    identity { 
        type = "SystemAssigned"
    }
}

# Enable web app managed identity to use storage account tables 
resource "azurerm_role_assignment" "backend_web_app_to_storage_account" {
    scope                = azurerm_storage_account.backend.id
    role_definition_name = "Storage Table Data Contributor"
    principal_id         = azurerm_linux_web_app.backend.identity.0.principal_id
}
