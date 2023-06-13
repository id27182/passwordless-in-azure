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
        storage_account_key  = azurerm_storage_account.backend.primary_access_key
    }
}