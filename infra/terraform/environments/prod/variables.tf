# ---------------------------------------------------------------------------
# Azure Authentication
# ---------------------------------------------------------------------------
variable "azure_tenant_id" { type = string; sensitive = true }
variable "azure_subscription_id" { type = string; sensitive = true }
variable "azure_client_id" { type = string; sensitive = true }
variable "azure_client_secret" { type = string; sensitive = true }

# ---------------------------------------------------------------------------
# Environment Settings
# ---------------------------------------------------------------------------
variable "environment" { type = string; default = "prod" }
variable "project_name" { type = string; default = "csp" }
variable "location" { type = string; default = "southcentralus" }

# ---------------------------------------------------------------------------
# Deployment Flags
# ---------------------------------------------------------------------------
variable "deploy_vnet" { type = bool; default = true }
variable "deploy_log_analytics" { type = bool; default = true }
variable "deploy_key_vault" { type = bool; default = true }
variable "deploy_web" { type = bool; default = true }
variable "deploy_data" { type = bool; default = true }

# ---------------------------------------------------------------------------
# Resource Parameters
# ---------------------------------------------------------------------------
variable "vnet_address_space" { type = string; default = "10.30.0.0/16" }
variable "snet_app_prefix" { type = string; default = "10.30.1.0/24" }
variable "snet_data_prefix" { type = string; default = "10.30.3.0/24" }

variable "web_sku_name" { type = string; default = "P1v3" }

variable "psql_sku_name" { type = string; default = "GP_Standard_D4ds_v4" }
variable "psql_storage_mb" { type = number; default = 131072 }
variable "redis_sku_name" { type = string; default = "Premium" }
variable "redis_capacity" { type = number; default = 1 }
variable "storage_replication" { type = string; default = "GZRS" }

# ---------------------------------------------------------------------------
# Custom Resource Names
# ---------------------------------------------------------------------------
variable "platform_rg_name" { type = string; default = "" }
variable "vnet_name" { type = string; default = "" }
variable "snet_app_name" { type = string; default = "" }
variable "snet_data_name" { type = string; default = "" }
variable "law_name" { type = string; default = "" }
variable "kv_name" { type = string; default = "" }

variable "web_asp_name" { type = string; default = "" }
variable "web_app_name" { type = string; default = "" }
variable "web_appi_name" { type = string; default = "" }

variable "data_psql_name" { type = string; default = "" }
variable "data_redis_name" { type = string; default = "" }
variable "data_storage_name" { type = string; default = "" }
variable "data_search_name" { type = string; default = "" }
