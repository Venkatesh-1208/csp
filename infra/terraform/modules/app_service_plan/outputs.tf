output "id" { value = one(azurerm_service_plan.this[*].id) }
output "name" { value = one(azurerm_service_plan.this[*].name) }
output "location" { value = one(azurerm_service_plan.this[*].location) }
