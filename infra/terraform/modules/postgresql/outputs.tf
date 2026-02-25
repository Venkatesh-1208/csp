output "id" { value = try(azurerm_postgresql_flexible_server.this[0].id, null) }
output "fqdn" { value = try(azurerm_postgresql_flexible_server.this[0].fqdn, null) }
output "name" { value = try(azurerm_postgresql_flexible_server.this[0].name, null) }
