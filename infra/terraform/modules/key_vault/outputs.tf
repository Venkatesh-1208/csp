output "vault_id" {
  description = "Resource ID of the Key Vault"
  value       = one(azurerm_key_vault.this[*].id)
}

output "vault_uri" {
  description = "URI of the Key Vault"
  value       = one(azurerm_key_vault.this[*].vault_uri)
}

output "vault_name" {
  description = "Name of the Key Vault"
  value       = one(azurerm_key_vault.this[*].name)
}
