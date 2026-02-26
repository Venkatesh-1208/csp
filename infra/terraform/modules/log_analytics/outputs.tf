output "workspace_id" {
  description = "Resource ID of the workspace"
  value       = one(azurerm_log_analytics_workspace.this[*].id)
}

output "id" {
  description = "Log Analytics Workspace ID"
  value       = one(azurerm_log_analytics_workspace.this[*].workspace_id)
}
