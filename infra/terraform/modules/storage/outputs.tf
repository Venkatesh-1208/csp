output "id" { value = try(azurerm_storage_account.this[0].id, null) }
output "name" { value = try(azurerm_storage_account.this[0].name, null) }
output "primary_connection_string" { value = try(azurerm_storage_account.this[0].primary_connection_string, null); sensitive = true }
