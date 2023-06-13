resource "azurerm_storage_account" "backend" {
    name                     = "${replace(var.rg_name, "-", "")}basa"
    resource_group_name      = azurerm_resource_group.main.name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    # Disable authorisation using storage account keys -
    # use Azure AD only
    shared_access_key_enabled = false
}