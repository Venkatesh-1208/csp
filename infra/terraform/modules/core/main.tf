# ---------------------------------------------------------------------------
# Core Module - Resource Group, VNet, Log Analytics, Key Vault
# ---------------------------------------------------------------------------

locals {
  rg_name        = "rg-${var.project}-core-${var.environment}-${var.location_short}"
  vnet_name      = "vnet-${var.project}-${var.environment}-${var.location_short}"
  snet_app_name  = "snet-${var.project}-app-${var.environment}-${var.location_short}"
  snet_data_name = "snet-${var.project}-data-${var.environment}-${var.location_short}"
  law_name       = "log-${var.project}-${var.environment}-${var.location_short}"
  kv_name        = "kv-${var.project}-${var.environment}-${var.location_short}"

  core_tags = merge(var.common_tags, {
    Tier = "core"
  })
}

# ---------------------------------------------------------------------------
# Resource Group
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "core" {
  name     = local.rg_name
  location = var.location
  tags     = local.core_tags
}

# ---------------------------------------------------------------------------
# Virtual Network
# ---------------------------------------------------------------------------
resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.core.name
  location            = azurerm_resource_group.core.location
  address_space       = ["10.10.0.0/16"]
  tags                = local.core_tags
}

# App Subnet (with App Service VNet Integration delegation)
resource "azurerm_subnet" "app" {
  name                 = local.snet_app_name
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.10.1.0/24"]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

# Data Subnet (no delegation – used for private endpoints / DB access)
resource "azurerm_subnet" "data" {
  name                 = local.snet_data_name
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.10.3.0/24"]
}

# ---------------------------------------------------------------------------
# Log Analytics Workspace
# ---------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "main" {
  name                = local.law_name
  resource_group_name = azurerm_resource_group.core.name
  location            = azurerm_resource_group.core.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.core_tags
}

# ---------------------------------------------------------------------------
# Key Vault  (RBAC-authorisation mode, soft-delete enabled)
# ---------------------------------------------------------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = local.kv_name
  resource_group_name        = azurerm_resource_group.core.name
  location                   = azurerm_resource_group.core.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = merge(local.core_tags, {
    DataClassification = "internal"
  })
}

# Grant the deploying Service Principal Key Vault Secrets Officer
# so that the data module can write secrets during apply.
resource "azurerm_role_assignment" "kv_sp_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
