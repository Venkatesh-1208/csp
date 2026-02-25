output "id" { value = try(azurerm_service_plan.this[0].id, null) }
output "name" { value = try(azurerm_service_plan.this[0].name, null) }
output "location" { value = try(azurerm_service_plan.this[0].location, null) }
