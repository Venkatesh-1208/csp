output "vault_id" {
  description = "Resource ID of the Key Vault"
  value       = try(azurerm_key_vault.this[0].id, null)
}

output "vault_uri" {
  description = "URI of the Key Vault"
  value       = try(azurerm_key_vault.this[0].vault_uri, null)
}

output "vault_name" {
  description = "Name of the Key Vault"
  value       = try(azurerm_key_vault.this[0].name, null)
}
