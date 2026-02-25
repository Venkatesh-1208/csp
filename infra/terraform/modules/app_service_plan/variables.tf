variable "deploy" { type = bool; default = true }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "os_type" { type = string; default = "Linux" }
variable "sku_name" { type = string; default = "B1" }
variable "tags" { type = map(string); default = {} }
