# ---------------------------------------------------------------------------
# Redis Cache Module
# ---------------------------------------------------------------------------
resource "azurerm_redis_cache" "this" {
  count                = var.deploy ? 1 : 0
  name                 = var.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  capacity             = var.capacity
  family               = contains(["Premium"], var.sku_name) ? "P" : "C"
  sku_name             = var.sku_name
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
  tags                 = var.tags
}

resource "azurerm_key_vault_secret" "connection_string" {
  count        = var.deploy && var.key_vault_id != null ? 1 : 0
  name         = "${var.name}-connection-string"
  value        = "${one(azurerm_redis_cache.this[*].hostname)}:6380,password=${one(azurerm_redis_cache.this[*].primary_access_key)},ssl=True,abortConnect=False"
  key_vault_id = var.key_vault_id
}
