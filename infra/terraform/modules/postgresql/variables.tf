variable "deploy" { type = bool; default = true }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_username" { type = string; default = "cspadmin" }
variable "sku_name" { type = string; default = "B_Standard_B1ms" }
variable "storage_mb" { type = number; default = 32768 }
variable "databases" { type = list(string); default = [] }
variable "key_vault_id" { type = string; default = null }
variable "tags" { type = map(string); default = {} }
