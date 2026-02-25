variable "deploy" { type = bool; default = true }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sku_name" { type = string; default = "Basic" }
variable "capacity" { type = number; default = 0 }
variable "key_vault_id" { type = string; default = null }
variable "tags" { type = map(string); default = {} }
