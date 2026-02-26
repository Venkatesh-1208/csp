output "id" { value = one(azurerm_search_service.this[*].id) }
output "name" { value = one(azurerm_search_service.this[*].name) }
output "primary_key" { value = one(azurerm_search_service.this[*].primary_key); sensitive = true }
