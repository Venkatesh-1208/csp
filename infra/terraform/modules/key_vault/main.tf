# ---------------------------------------------------------------------------
# Key Vault Module (RBAC mode, soft-delete enabled)
# ---------------------------------------------------------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  count                      = var.deploy ? 1 : 0
  name                       = var.vault_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  enable_rbac_authorization  = true
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  tags = merge(var.tags, {
    DataClassification = "internal"
  })
}

# Grant the deploying Service Principal Key Vault Secrets Officer
resource "azurerm_role_assignment" "kv_sp_secrets_officer" {
  count                = var.deploy ? 1 : 0
  scope                = one(azurerm_key_vault.this[*].id)
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
