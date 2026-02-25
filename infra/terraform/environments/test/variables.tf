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
variable "environment" { type = string; default = "test" }
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
variable "vnet_address_space" { type = string; default = "10.20.0.0/16" }
variable "snet_app_prefix" { type = string; default = "10.20.1.0/24" }
variable "snet_data_prefix" { type = string; default = "10.20.3.0/24" }

variable "web_sku_name" { type = string; default = "B2" }

variable "psql_sku_name" { type = string; default = "GP_Standard_D2ds_v4" }
variable "psql_storage_mb" { type = number; default = 65536 }
variable "redis_sku_name" { type = string; default = "Standard" }
variable "redis_capacity" { type = number; default = 1 }
variable "storage_replication" { type = string; default = "GRS" }

# ---------------------------------------------------------------------------
# Custom Resource Names
# ---------------------------------------------------------------------------
variable "platform_rg_name" { type = string; default = "" }
variable "vnet_name" { type = string; default = "" }
variable "snet_app_name" { type = string; default = "" }
variable "snet_data_name" { type = string; default = "" }
variable "law_name" { type = string; default = "" }
variable "kv_name" { type = string; default = "" }

variable "web_rg_name" { type = string; default = "" }
variable "web_asp_name" { type = string; default = "" }
variable "web_app_name" { type = string; default = "" }
variable "web_appi_name" { type = string; default = "" }

variable "data_rg_name" { type = string; default = "" }
variable "data_psql_name" { type = string; default = "" }
variable "data_redis_name" { type = string; default = "" }
variable "data_storage_name" { type = string; default = "" }
variable "data_search_name" { type = string; default = "" }
