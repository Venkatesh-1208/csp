terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# ---------------------------------------------------------------------------
# Provider
# ---------------------------------------------------------------------------
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}

# ---------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------
locals {
  project     = var.project_name          # "csp"
  env         = var.environment           # "dev"
  location    = var.location              # "southcentralus"
  location_short = "scus"

  common_tags = {
    Environment    = local.env
    Project        = "CSP-Portal"
    Application    = "csp-portal"
    CostCenter     = "CC-CSP-DEV-001"
    Owner          = "platform-engineering"
    ManagedBy      = "terraform"
    Criticality    = "low"
  }
}

# ---------------------------------------------------------------------------
# Core Infrastructure Module
# ---------------------------------------------------------------------------
module "core" {
  source = "./modules/core"

  project        = local.project
  environment    = local.env
  location       = local.location
  location_short = local.location_short
  common_tags    = local.common_tags
}

# ---------------------------------------------------------------------------
# Web Tier Module
# ---------------------------------------------------------------------------
module "web" {
  count  = var.deploy_web ? 1 : 0
  source = "./modules/web"

  project              = local.project
  environment          = local.env
  location             = local.location
  location_short       = local.location_short
  common_tags          = local.common_tags
  log_analytics_id     = module.core.log_analytics_workspace_id
  azure_subscription_id = var.azure_subscription_id

  depends_on = [module.core]
}

# ---------------------------------------------------------------------------
# Data Tier Module
# ---------------------------------------------------------------------------
module "data" {
  count  = var.deploy_data ? 1 : 0
  source = "./modules/data"

  project        = local.project
  environment    = local.env
  location       = local.location
  location_short = local.location_short
  common_tags    = local.common_tags
  key_vault_id   = module.core.key_vault_id
  key_vault_name = module.core.key_vault_name

  depends_on = [module.core]
}
