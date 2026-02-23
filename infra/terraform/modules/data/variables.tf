variable "project" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "location_short" { type = string }
variable "common_tags" { type = map(string) }
variable "key_vault_id" {
  description = "Resource ID of the Core Key Vault (for RBAC role assignment)"
  type        = string
}
variable "key_vault_name" {
  description = "Name of the Core Key Vault (for writing secrets)"
  type        = string
}
