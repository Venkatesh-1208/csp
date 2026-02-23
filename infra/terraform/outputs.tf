# ---------------------------------------------------------------------------
# Core Outputs
# ---------------------------------------------------------------------------
output "core_vnet_id" {
  description = "Resource ID of the core Virtual Network"
  value       = module.core.vnet_id
}

output "core_app_subnet_id" {
  description = "Resource ID of the App subnet"
  value       = module.core.app_subnet_id
}

output "core_data_subnet_id" {
  description = "Resource ID of the Data subnet"
  value       = module.core.data_subnet_id
}

output "core_log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace"
  value       = module.core.log_analytics_workspace_id
}

output "core_key_vault_name" {
  description = "Name of the Core Key Vault"
  value       = module.core.key_vault_name
}

output "core_key_vault_id" {
  description = "Resource ID of the Core Key Vault"
  value       = module.core.key_vault_id
}

# ---------------------------------------------------------------------------
# Web Outputs
# ---------------------------------------------------------------------------
output "web_app_hostname" {
  description = "Default hostname of the Web App"
  value       = var.deploy_web ? module.web[0].web_app_hostname : null
}

output "web_app_identity_principal_id" {
  description = "System-assigned Managed Identity principal ID of the Web App"
  value       = var.deploy_web ? module.web[0].web_app_identity_principal_id : null
}

# ---------------------------------------------------------------------------
# Data Outputs
# ---------------------------------------------------------------------------
output "postgresql_fqdn" {
  description = "FQDN of the PostgreSQL Flexible Server"
  value       = var.deploy_data ? module.data[0].postgresql_fqdn : null
}

output "redis_hostname" {
  description = "Hostname of the Redis Cache"
  value       = var.deploy_data ? module.data[0].redis_hostname : null
}

output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = var.deploy_data ? module.data[0].storage_account_name : null
}

output "search_service_name" {
  description = "Name of the AI Search service"
  value       = var.deploy_data ? module.data[0].search_service_name : null
}
