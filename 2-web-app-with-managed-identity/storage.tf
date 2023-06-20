resource "azurerm_storage_account" "backend" {
    name                     = "${replace(var.rg_name, "-", "")}basa"
    resource_group_name      = azurerm_resource_group.main.name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    # Disable authorisation using storage account keys -
    # use Azure AD only. 
    # 
    # When setting this property from terraform, we need to introduce 
    # two additional code changes, othervise subsequent runs of terraform will fail: 
    # - update provider configuration to switch form key-based to
    #   RBAC authentification for the storage account. More details 
    #   in the provider documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account.html#shared_access_key_enabled. 
    #   Added it to the terraform.tf, line 14. 
    # - as now we are using the RBAC authorisation on the storage 
    #   accounts, we need to add explicit role assignments with the 
    #   storage roles for the identity, used to run terraform. 
    #   See the notes in provider documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#storage_use_azuread. 
    #   Added it to storage.tf, line 26
    shared_access_key_enabled = false
}

data "azurerm_client_config" "current" {}
resource "azurerm_role_assignment" "terraform_identity_storage_roles" { 
    scope                = azurerm_resource_group.main.id
    role_definition_name = "Storage Account Contributor"
    principal_id         =  data.azurerm_client_config.current.object_id
}