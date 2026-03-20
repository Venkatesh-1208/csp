resource "azurerm_service_plan" "this" {
  name                = "${var.name}-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = var.always_on
    linux_fx_version = "DOCKER|${var.acr_login_server}/${var.docker_image}"
  }

  app_settings = var.app_settings
  tags         = var.tags
}
