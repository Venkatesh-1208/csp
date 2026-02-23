terraform {
  backend "azurerm" {
    # These values are injected via -backend-config flags in CI
    # or a partial backend config file (do NOT hard-code SAS keys here)
    resource_group_name  = "rg-csp-tfstate-scus"
    storage_account_name = "stcspterraformscus"
    container_name       = "tfstate"
    key                  = "csp-portal/dev/terraform.tfstate"
  }
}
