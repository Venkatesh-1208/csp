# ---------------------------------------------------------------------------
# Storage Account Module
# ---------------------------------------------------------------------------
resource "azurerm_storage_account" "this" {
  count                           = var.deploy ? 1 : 0
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = var.account_replication_type
  account_kind                    = "StorageV2"
  access_tier                     = "Hot"
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_container" "containers" {
  for_each              = var.deploy ? toset(var.containers) : toset([])
  name                  = each.key
  storage_account_id    = one(azurerm_storage_account.this[*].id)
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "connection_string" {
  count        = var.deploy && var.key_vault_id != null ? 1 : 0
  name         = "${var.name}-connection-string"
  value        = one(azurerm_storage_account.this[*].primary_connection_string)
  key_vault_id = var.key_vault_id
}
