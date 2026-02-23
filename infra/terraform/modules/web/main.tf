# ---------------------------------------------------------------------------
# Web Module - App Service Plan, Web App, App Insights, Staging Slot
# ---------------------------------------------------------------------------

locals {
  rg_name    = "rg-${var.project}-web-${var.environment}-${var.location_short}"
  asp_name   = "asp-${var.project}-web-${var.environment}-${var.location_short}"
  app_name   = "app-${var.project}-web-${var.environment}-${var.location_short}"
  appi_name  = "appi-${var.project}-web-${var.environment}-${var.location_short}"

  web_tags = merge(var.common_tags, {
    Tier  = "web"
    Phase = "phase-1"
  })
}

# ---------------------------------------------------------------------------
# Resource Group
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "web" {
  name     = local.rg_name
  location = var.location
  tags     = local.web_tags
}

# ---------------------------------------------------------------------------
# App Service Plan (Linux B1)
# ---------------------------------------------------------------------------
resource "azurerm_service_plan" "web" {
  name                = local.asp_name
  resource_group_name = azurerm_resource_group.web.name
  location            = azurerm_resource_group.web.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = local.web_tags
}

# ---------------------------------------------------------------------------
# Application Insights (workspace-based)
# ---------------------------------------------------------------------------
resource "azurerm_application_insights" "web" {
  name                = local.appi_name
  resource_group_name = azurerm_resource_group.web.name
  location            = azurerm_resource_group.web.location
  workspace_id        = var.log_analytics_id
  application_type    = "web"
  tags                = local.web_tags
}

# ---------------------------------------------------------------------------
# Web App (.NET 8, HTTPS-only, System-assigned identity)
# ---------------------------------------------------------------------------
resource "azurerm_linux_web_app" "web" {
  name                = local.app_name
  resource_group_name = azurerm_resource_group.web.name
  location            = azurerm_resource_group.web.location
  service_plan_id     = azurerm_service_plan.web.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = false
    minimum_tls_version = "1.2"
    ftps_state       = "Disabled"

    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.web.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.web.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    ASPNETCORE_ENVIRONMENT                     = "Development"
  }

  tags = local.web_tags
}

# ---------------------------------------------------------------------------
# Staging Deployment Slot
# ---------------------------------------------------------------------------
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.web.id

  site_config {
    always_on           = false
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"

    application_stack {
      dotnet_version = "8.0"
    }
  }

  tags = local.web_tags
}
