# ---------------------------------------------------------------------------
# Log Analytics Workspace Module
# ---------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "this" {
  count               = var.deploy ? 1 : 0
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}
