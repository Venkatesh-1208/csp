output "vnet_id" { value = var.deploy ? azurerm_virtual_network.this[0].id : null }
output "subnet_app_id" { value = var.deploy ? azurerm_subnet.app[0].id : null }
output "subnet_db_id" { value = var.deploy ? azurerm_subnet.db[0].id : null }
output "subnet_storage_id" { value = var.deploy ? azurerm_subnet.storage[0].id : null }
output "subnet_keyvault_id" { value = var.deploy ? azurerm_subnet.keyvault[0].id : null }
