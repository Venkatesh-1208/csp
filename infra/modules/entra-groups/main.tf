resource "azuread_group" "admins" {
  display_name     = "csp-admins-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "developers" {
  display_name     = "csp-developers-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "readonly" {
  display_name     = "csp-readonly-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "customers" {
  display_name     = "csp-customers-${var.environment}"
  security_enabled = true
}
