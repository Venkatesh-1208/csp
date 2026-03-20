output "resource_group_id" { value = azurerm_resource_group.rg.id }
output "backend_url" { value = module.app_service.default_hostname }
output "frontend_url" { value = module.static_web_app.default_host_name }
output "db_fqdn" { value = module.postgresql.fqdn }
output "acs_connection_string" {
  value     = module.communication.primary_connection_string
  sensitive = true
}
