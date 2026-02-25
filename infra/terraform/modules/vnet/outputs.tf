output "vnet_id" {
  description = "Resource ID of the VNet"
  value       = try(azurerm_virtual_network.this[0].id, null)
}

output "vnet_name" {
  description = "Name of the VNet"
  value       = try(azurerm_virtual_network.this[0].name, null)
}

output "app_subnet_id" {
  description = "Resource ID of the app subnet"
  value       = try(azurerm_subnet.app[0].id, null)
}

output "data_subnet_id" {
  description = "Resource ID of the data subnet"
  value       = try(azurerm_subnet.data[0].id, null)
}
