output "id" { value = try(azurerm_linux_web_app.this[0].id, null) }
output "name" { value = try(azurerm_linux_web_app.this[0].name, null) }
output "default_hostname" { value = try(azurerm_linux_web_app.this[0].default_hostname, null) }
output "identity_principal_id" { value = try(azurerm_linux_web_app.this[0].identity[0].principal_id, null) }
