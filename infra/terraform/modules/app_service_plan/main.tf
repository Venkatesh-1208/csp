# ---------------------------------------------------------------------------
# App Service Plan Module
# ---------------------------------------------------------------------------
resource "azurerm_service_plan" "this" {
  count               = var.deploy ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}
