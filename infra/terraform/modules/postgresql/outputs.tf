output "id" { value = one(azurerm_postgresql_flexible_server.this[*].id) }
output "fqdn" { value = one(azurerm_postgresql_flexible_server.this[*].fqdn) }
output "name" { value = one(azurerm_postgresql_flexible_server.this[*].name) }
