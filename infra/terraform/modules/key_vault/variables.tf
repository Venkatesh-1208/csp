variable "deploy" {
  description = "Whether to deploy the Key Vault"
  type        = bool
  default     = true
}

variable "vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_name" {
  description = "SKU for the Key Vault"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}
