# ---------------------------------------------------------------------------
# Root Module for TEST Environment
# ---------------------------------------------------------------------------

locals {
  location_short = "scus" # mapped from southcentralus
  common_tags = {
    Environment    = var.environment
    Project        = var.project_name
    ManagedBy      = "terraform"
  }
}

# ---------------------------------------------------------------------------
# Platform - Resource Group
# ---------------------------------------------------------------------------
module "resource_group" {
  source = "../../modules/resource_group"

  deploy   = var.deploy_vnet || var.deploy_log_analytics || var.deploy_key_vault || var.deploy_web || var.deploy_data
  name     = var.platform_rg_name != "" ? var.platform_rg_name : "rg-${var.project_name}-platform-${var.environment}-${local.location_short}"
  location = var.location
  tags     = local.common_tags
}

# ---------------------------------------------------------------------------
# Network - VNet
# ---------------------------------------------------------------------------
module "network" {
  source = "../../modules/vnet"

  deploy              = var.deploy_vnet
  vnet_name           = var.vnet_name != "" ? var.vnet_name : "vnet-${var.project_name}-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  address_space       = var.vnet_address_space
  snet_app_name       = var.snet_app_name != "" ? var.snet_app_name : "snet-${var.project_name}-app-${var.environment}-${local.location_short}"
  snet_app_prefix     = var.snet_app_prefix
  snet_data_name      = var.snet_data_name != "" ? var.snet_data_name : "snet-${var.project_name}-data-${var.environment}-${local.location_short}"
  snet_data_prefix    = var.snet_data_prefix
  tags                = local.common_tags

}

# ---------------------------------------------------------------------------
# Monitoring - Log Analytics
# ---------------------------------------------------------------------------
module "monitoring" {
  source = "../../modules/log_analytics"

  deploy              = var.deploy_log_analytics
  workspace_name      = var.law_name != "" ? var.law_name : "log-${var.project_name}-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku                 = "PerGB2018"
  tags                = local.common_tags

}

# ---------------------------------------------------------------------------
# Security - Key Vault
# ---------------------------------------------------------------------------
module "security" {
  source = "../../modules/key_vault"

  deploy              = var.deploy_key_vault
  vault_name          = var.kv_name != "" ? var.kv_name : "kv-${var.project_name}-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = local.common_tags

}

# ---------------------------------------------------------------------------
# Monitoring - App Insights
# ---------------------------------------------------------------------------
module "app_insights" {
  source = "../../modules/app_insights"

  deploy              = var.deploy_web
  name                = var.web_appi_name != "" ? var.web_appi_name : "appi-${var.project_name}-web-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  workspace_id        = module.monitoring.workspace_id
  tags                = local.common_tags
}

# ---------------------------------------------------------------------------
# Web - App Service Plan
# ---------------------------------------------------------------------------
module "app_service_plan" {
  source = "../../modules/app_service_plan"

  deploy              = var.deploy_web
  name                = var.web_asp_name != "" ? var.web_asp_name : "asp-${var.project_name}-web-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku_name            = var.web_sku_name
  tags                = local.common_tags
}

# ---------------------------------------------------------------------------
# Web - Linux Web App
# ---------------------------------------------------------------------------
module "web_app" {
  source = "../../modules/linux_web_app"

  deploy              = var.deploy_web
  name                = var.web_app_name != "" ? var.web_app_name : "app-${var.project_name}-web-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  service_plan_id     = module.app_service_plan.id
  always_on           = var.web_sku_name == "F1" || var.web_sku_name == "D1" || var.web_sku_name == "B1" ? false : true
  staging_slot_enabled = var.web_sku_name == "F1" || var.web_sku_name == "D1" || var.web_sku_name == "B1" ? false : true
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = module.app_insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = module.app_insights.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    ASPNETCORE_ENVIRONMENT                     = var.environment == "prod" ? "Production" : "Development"
  }
  tags = local.common_tags
}

# ---------------------------------------------------------------------------
# Data - PostgreSQL
# ---------------------------------------------------------------------------
module "postgresql" {
  source = "../../modules/postgresql"

  deploy              = var.deploy_data
  name                = var.data_psql_name != "" ? var.data_psql_name : "psql-${var.project_name}-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku_name            = var.psql_sku_name
  storage_mb          = var.psql_storage_mb
  databases           = ["csp_identity", "csp_requests", "csp_reservations", "csp_licenses", "csp_customers", "csp_procurement", "csp_notifications", "csp_reports", "csp_audit"]
  key_vault_id        = module.security.vault_id
  tags                = local.common_tags
}

# ---------------------------------------------------------------------------
# Data - Redis
# ---------------------------------------------------------------------------
module "redis" {
  source = "../../modules/redis"

  deploy              = var.deploy_data
  name                = var.data_redis_name != "" ? var.data_redis_name : "redis-${var.project_name}-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku_name            = var.redis_sku_name
  capacity            = var.redis_capacity
  key_vault_id        = module.security.vault_id
  tags                = local.common_tags
}

# ---------------------------------------------------------------------------
# Data - Storage
# ---------------------------------------------------------------------------
module "storage" {
  source = "../../modules/storage"

  deploy                   = var.deploy_data
  name                     = var.data_storage_name != "" ? var.data_storage_name : replace("st${var.project_name}${var.environment}${local.location_short}001", "-", "")
  resource_group_name      = module.resource_group.name
  location                 = var.location
  account_replication_type = var.storage_replication
  containers               = ["documents", "attachments", "reports"]
  key_vault_id             = module.security.vault_id
  tags                     = local.common_tags
}

# ---------------------------------------------------------------------------
# Data - AI Search
# ---------------------------------------------------------------------------
module "search" {
  source = "../../modules/search"

  deploy              = var.deploy_data
  name                = var.data_search_name != "" ? var.data_search_name : "srch-${var.project_name}-${var.environment}-${local.location_short}"
  resource_group_name = module.resource_group.name
  location            = var.location
  key_vault_id        = module.security.vault_id
  tags                = local.common_tags
}
