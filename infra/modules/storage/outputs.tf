output "id" { value = azurerm_storage_account.this.id }
output "primary_connection_string" {
  value     = azurerm_storage_account.this.primary_connection_string
  sensitive = true
}
output "primary_blob_endpoint" { value = azurerm_storage_account.this.primary_blob_endpoint }
