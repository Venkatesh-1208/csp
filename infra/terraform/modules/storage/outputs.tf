output "id" { value = one(azurerm_storage_account.this[*].id) }
output "name" { value = one(azurerm_storage_account.this[*].name) }
output "primary_connection_string" { value = one(azurerm_storage_account.this[*].primary_connection_string); sensitive = true }
