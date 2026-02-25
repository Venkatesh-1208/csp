output "name" {
  description = "Name of the resource group"
  value       = try(azurerm_resource_group.this[0].name, null)
}

output "location" {
  description = "Location of the resource group"
  value       = try(azurerm_resource_group.this[0].location, null)
}

output "id" {
  description = "Resource ID of the resource group"
  value       = try(azurerm_resource_group.this[0].id, null)
}
