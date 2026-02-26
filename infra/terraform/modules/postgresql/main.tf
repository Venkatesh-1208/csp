# ---------------------------------------------------------------------------
# PostgreSQL Flexible Server Module
# ---------------------------------------------------------------------------
resource "random_password" "psql_admin" {
  count            = var.deploy ? 1 : 0
  length           = 20
  special          = true
  override_special = "!@#$%"
}

resource "azurerm_postgresql_flexible_server" "this" {
  count                  = var.deploy ? 1 : 0
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "16"
  administrator_login    = var.admin_username
  administrator_password = random_password.psql_admin[0].result
  zone                   = "1"

  sku_name   = var.sku_name
  storage_mb = var.storage_mb

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  high_availability {
    mode = "Disabled"
  }

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_configuration" "require_ssl" {
  count     = var.deploy ? 1 : 0
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.this[0].id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each  = var.deploy ? toset(var.databases) : toset([])
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.this[0].id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Key Vault Secrets for the DB
resource "azurerm_key_vault_secret" "admin_password" {
  count        = var.deploy && var.key_vault_id != null ? 1 : 0
  name         = "${var.name}-admin-password"
  value        = random_password.psql_admin[0].result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "admin_username" {
  count        = var.deploy && var.key_vault_id != null ? 1 : 0
  name         = "${var.name}-admin-username"
  value        = var.admin_username
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "connection_string" {
  count = var.deploy && var.key_vault_id != null ? 1 : 0
  name  = "${var.name}-connection-string"
  value = "Host=${azurerm_postgresql_flexible_server.this[0].fqdn};Database=${length(var.databases) > 0 ? var.databases[0] : "postgres"};Username=${var.admin_username};Password=${random_password.psql_admin[0].result};SSL Mode=Require;"
  key_vault_id = var.key_vault_id
}
