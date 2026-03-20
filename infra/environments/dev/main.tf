locals {
  env      = "dev"
  app      = "csp"
  location = "eastus"
  tags = {
    Environment = "dev"
    Project     = "CSP-Portal"
    ManagedBy   = "Terraform"
    Owner       = "Admin"
    CostCenter  = "12345"
  }
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.app}-${local.env}"
  location = local.location
  tags     = local.tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${local.app}-law-${local.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_application_insights" "appi" {
  name                = "${local.app}-appi-${local.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags                = local.tags
}

module "networking" {
  source = "../../modules/networking"

  deploy              = false
  name                = "${local.app}-vnet-${local.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = "10.0.0.0/16"
  subnets = {
    app      = "10.0.1.0/24"
    db       = "10.0.2.0/24"
    storage  = "10.0.3.0/24"
    keyvault = "10.0.4.0/24"
  }
  tags = local.tags
}

module "entra_groups" {
  source      = "../../modules/entra-groups"
  environment = local.env
}

# Role Assignments
resource "azurerm_role_assignment" "admin_rg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = module.entra_groups.admins_id
}

resource "azurerm_role_assignment" "dev_rg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = module.entra_groups.developers_id
}

resource "azurerm_role_assignment" "ro_rg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = module.entra_groups.readonly_id
}

module "keyvault" {
  source              = "../../modules/keyvault"
  name                = "${local.app}-kv-${local.env}-${substr(data.azurerm_subscription.current.subscription_id, 0, 4)}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
}

module "storage" {
  source                   = "../../modules/storage"
  name                     = "${local.app}st${local.env}001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  public_access            = true
  versioning_enabled       = false
  tags                     = local.tags
}

resource "random_password" "postgres" {
  length  = 16
  special = true
}

module "postgresql" {
  source                = "../../modules/postgresql"
  name                  = "${local.app}-pgsql-${local.env}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  sku_name              = "B1ms"
  admin_username        = "psqladmin"
  admin_password        = random_password.postgres.result
  database_name         = "csp_portal_${local.env}"
  backup_retention_days = 7
  geo_redundant_backup  = false
  high_availability     = false
  tags                  = local.tags
}

module "acr" {
  source                   = "../../modules/container-registry"
  name                     = replace("${local.app}acr${local.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  geo_replication_location = ""
  tags                     = local.tags
}

module "static_web_app" {
  source              = "../../modules/static-web-app"
  name                = "${local.app}-swa-${local.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_tier            = "Free"
  sku_size            = "Free"
  tags                = local.tags
}

module "app_service" {
  source              = "../../modules/app-service"
  name                = "${local.app}-backend-${local.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "B1"
  always_on           = false
  acr_login_server    = module.acr.login_server
  docker_image        = "backend:latest"
  app_settings = {
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "1800"
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = azurerm_application_insights.appi.instrumentation_key
    "DB_CONNECTION"                       = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_conn.id})"
  }
  tags = local.tags
}

# Role assignment for App Service to KV and Storage
resource "azurerm_role_assignment" "app_kv" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service.principal_id
}

resource "azurerm_role_assignment" "app_storage" {
  scope                = module.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.app_service.principal_id
}

# Secrets
resource "azurerm_key_vault_secret" "db_conn" {
  name         = "PgsqlConnectionString"
  value        = "Host=${module.postgresql.fqdn};Database=csp_portal_${local.env};Username=psqladmin;Password=${random_password.postgres.result}"
  key_vault_id = module.keyvault.id
  depends_on   = [azurerm_role_assignment.admin_rg]
}

resource "azurerm_key_vault_secret" "storage_conn" {
  name         = "BlobStorageConnectionString"
  value        = module.storage.primary_connection_string
  key_vault_id = module.keyvault.id
  depends_on   = [azurerm_role_assignment.admin_rg]
}

module "communication" {
  source              = "../../modules/communication-services"
  name                = "${local.app}-acs-${local.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
}

resource "azurerm_key_vault_secret" "acs_conn" {
  name         = "AcsConnectionString"
  value        = module.communication.primary_connection_string
  key_vault_id = module.keyvault.id
  depends_on   = [azurerm_role_assignment.admin_rg]
}
