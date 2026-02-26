output "id" { value = one(azurerm_linux_web_app.this[*].id) }
output "name" { value = one(azurerm_linux_web_app.this[*].name) }
output "default_hostname" { value = one(azurerm_linux_web_app.this[*].default_hostname) }
output "identity_principal_id" { value = one(azurerm_linux_web_app.this[*].identity[0].principal_id) }
