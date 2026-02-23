output "web_app_hostname" {
  value = azurerm_linux_web_app.web.default_hostname
}

output "web_app_identity_principal_id" {
  value = azurerm_linux_web_app.web.identity[0].principal_id
}

output "app_insights_instrumentation_key" {
  value     = azurerm_application_insights.web.instrumentation_key
  sensitive = true
}
