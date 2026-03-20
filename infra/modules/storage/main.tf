resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    versioning_enabled = var.versioning_enabled
  }

  public_network_access_enabled = var.public_access

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = "attachments"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = var.public_access ? "blob" : "private"
}
