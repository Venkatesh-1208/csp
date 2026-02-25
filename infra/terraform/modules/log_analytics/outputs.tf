output "workspace_id" {
  description = "Resource ID of the workspace"
  value       = try(azurerm_log_analytics_workspace.this[0].id, null)
}

output "id" {
  description = "Log Analytics Workspace ID"
  value       = try(azurerm_log_analytics_workspace.this[0].workspace_id, null)
}
