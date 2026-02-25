output "id" { value = try(azurerm_application_insights.this[0].id, null) }
output "instrumentation_key" { value = try(azurerm_application_insights.this[0].instrumentation_key, null); sensitive = true }
output "connection_string" { value = try(azurerm_application_insights.this[0].connection_string, null); sensitive = true }
