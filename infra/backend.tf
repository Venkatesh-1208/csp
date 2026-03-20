terraform {
  backend "azurerm" {
    # Configure via cli `terraform init -backend-config=...`
    # resource_group_name  = "rg-terraform-state"
    # storage_account_name = "sttfstateglobal"
    # container_name       = "tfstate"
    # key                  = "env.tfstate"
  }
}
