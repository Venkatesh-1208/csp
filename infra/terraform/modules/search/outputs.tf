output "id" { value = try(azurerm_search_service.this[0].id, null) }
output "name" { value = try(azurerm_search_service.this[0].name, null) }
output "primary_key" { value = try(azurerm_search_service.this[0].primary_key, null); sensitive = true }
