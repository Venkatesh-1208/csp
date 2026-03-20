resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true

  dynamic "georeplications" {
    for_each = var.geo_replication_location != "" ? [1] : []
    content {
      location = var.geo_replication_location
    }
  }

  tags = var.tags
}
