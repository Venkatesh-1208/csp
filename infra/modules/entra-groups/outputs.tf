output "admins_id" { value = azuread_group.admins.object_id }
output "developers_id" { value = azuread_group.developers.object_id }
output "readonly_id" { value = azuread_group.readonly.object_id }
output "customers_id" { value = azuread_group.customers.object_id }
