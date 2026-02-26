output "vnet_id" {
  description = "Resource ID of the VNet"
  value       = one(azurerm_virtual_network.this[*].id)
}

output "vnet_name" {
  description = "Name of the VNet"
  value       = one(azurerm_virtual_network.this[*].name)
}

output "app_subnet_id" {
  description = "Resource ID of the app subnet"
  value       = one(azurerm_subnet.app[*].id)
}

output "data_subnet_id" {
  description = "Resource ID of the data subnet"
  value       = one(azurerm_subnet.data[*].id)
}
