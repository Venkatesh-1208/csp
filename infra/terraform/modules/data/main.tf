# ---------------------------------------------------------------------------
# Data Module - PostgreSQL, Redis, Storage, AI Search, KV secrets
# ---------------------------------------------------------------------------

locals {
  rg_name       = "rg-${var.project}-data-${var.environment}-${var.location_short}"
  psql_name     = "psql-${var.project}-${var.environment}-${var.location_short}"
  redis_name    = "redis-${var.project}-${var.environment}-${var.location_short}"
  storage_name  = "stcspdevscus001"
  search_name   = "srch-${var.project}-${var.environment}-${var.location_short}"

  databases = [
    "csp_identity",
    "csp_requests",
    "csp_reservations",
    "csp_licenses",
    "csp_customers",
    "csp_procurement",
    "csp_notifications",
    "csp_reports",
    "csp_audit",
  ]

  data_tags = merge(var.common_tags, {
    Tier               = "data"
    BackupPolicy       = "7-day"
    DataClassification = "internal"
  })
}

# ---------------------------------------------------------------------------
# Resource Group
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "data" {
  name     = local.rg_name
  location = var.location
  tags     = local.data_tags
}

# ---------------------------------------------------------------------------
# PostgreSQL Admin Password (random, stored in KV)
# ---------------------------------------------------------------------------
resource "random_password" "psql_admin" {
  length           = 20
  special          = true
  override_special = "!@#$%"
}

# ---------------------------------------------------------------------------
# PostgreSQL Flexible Server
# ---------------------------------------------------------------------------
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = local.psql_name
  resource_group_name    = azurerm_resource_group.data.name
  location               = azurerm_resource_group.data.location
  version                = "16"
  administrator_login    = "cspadmin"
  administrator_password = random_password.psql_admin.result
  zone                   = "1"

  sku_name   = "B_Standard_B1ms"  # Burstable B1ms
  storage_mb = 32768              # 32 GB

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  high_availability {
    mode = "Disabled"
  }

  # No public access – matches --public-access None
  # Private endpoint / VNet integration can be added as a follow-up
  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  tags = local.data_tags
}

# require_secure_transport = on
resource "azurerm_postgresql_flexible_server_configuration" "require_ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "on"
}

# Databases
resource "azurerm_postgresql_flexible_server_database" "databases" {
  for_each  = toset(local.databases)
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# ---------------------------------------------------------------------------
# Redis Cache (Basic C0)
# ---------------------------------------------------------------------------
resource "azurerm_redis_cache" "main" {
  name                = local.redis_name
  resource_group_name = azurerm_resource_group.data.name
  location            = azurerm_resource_group.data.location
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"
  tags                = local.data_tags
}

# ---------------------------------------------------------------------------
# Storage Account  (Standard LRS, hot, HTTPS-only, no public blob access)
# ---------------------------------------------------------------------------
resource "azurerm_storage_account" "main" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.data.name
  location                 = azurerm_resource_group.data.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  https_traffic_only_enabled      = true
  min_tls_version          = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                     = local.data_tags
}

resource "azurerm_storage_container" "documents" {
  name                  = "documents"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "attachments" {
  name                  = "attachments"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "reports" {
  name                  = "reports"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

# ---------------------------------------------------------------------------
# AI Search (Basic, 1 replica, 1 partition)
# ---------------------------------------------------------------------------
resource "azurerm_search_service" "main" {
  name                = local.search_name
  resource_group_name = azurerm_resource_group.data.name
  location            = azurerm_resource_group.data.location
  sku                 = "basic"
  replica_count       = 1
  partition_count     = 1
  tags                = local.data_tags
}

# ---------------------------------------------------------------------------
# Key Vault Secrets
# ---------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "psql_admin_password" {
  name         = "psql-admin-password"
  value        = random_password.psql_admin.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "psql_admin_username" {
  name         = "psql-admin-username"
  value        = "cspadmin"
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "psql_connection_string" {
  name  = "psql-connection-string"
  value = "Host=${azurerm_postgresql_flexible_server.main.fqdn};Database=csp_identity;Username=cspadmin;Password=${random_password.psql_admin.result};SSL Mode=Require;"
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name  = "redis-connection-string"
  value = "${azurerm_redis_cache.main.hostname}:6380,password=${azurerm_redis_cache.main.primary_access_key},ssl=True,abortConnect=False"
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "storage_connection_string" {
  name         = "storage-connection-string"
  value        = azurerm_storage_account.main.primary_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "search_admin_key" {
  name         = "search-admin-key"
  value        = azurerm_search_service.main.primary_key
  key_vault_id = var.key_vault_id
}
