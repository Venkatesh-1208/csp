# ---------------------------------------------------------------------------
# Linux Web App Module
# ---------------------------------------------------------------------------
resource "azurerm_linux_web_app" "this" {
  count               = var.deploy ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.service_plan_id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = var.always_on
    minimum_tls_version = "1.2"
    ftps_state       = "Disabled"

    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = var.app_settings

  tags = var.tags
}

resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.deploy && var.staging_slot_enabled ? 1 : 0
  name           = "staging"
  app_service_id = one(azurerm_linux_web_app.this[*].id)

  site_config {
    always_on           = var.always_on
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"

    application_stack {
      dotnet_version = "8.0"
    }
  }

  tags = var.tags
}
