# ---------------------------------------------------------------------------
# AI Search Module
# ---------------------------------------------------------------------------
resource "azurerm_search_service" "this" {
  count               = var.deploy ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "basic"
  replica_count       = 1
  partition_count     = 1
  tags                = var.tags
}

resource "azurerm_key_vault_secret" "admin_key" {
  count        = var.deploy && var.key_vault_id != null ? 1 : 0
  name         = "${var.name}-admin-key"
  value        = one(azurerm_search_service.this[*].primary_key)
  key_vault_id = var.key_vault_id
}
